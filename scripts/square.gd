extends CharacterBody2D

var health = 30
var separation_distance = 100.0  # Minimum distance to maintain between enemies


@onready var player = get_node("/root/main/player")
@onready var waveman = get_node("/root/main/WaveManager")
@onready var parent_node  # This will reference the parent node containing all enemies (other instances of this scene)
var timer
signal on_death()

var rng = RandomNumberGenerator.new()

func _ready():
	connect("on_death", waveman._on_mob_death)
	parent_node = get_parent()

func type0movement(direction):
	return direction* 600.0

func type1movement(direction):
	direction[1] = direction[1]*5000.0
	direction[0] = direction[0]*7500.0
	return direction

func type2movement(direction):
	direction[1] = direction[1]*7500.0
	direction[0] = direction[0]*5000.0
	return direction

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	var enemy_type = rng.randi_range(0, 50)
	if enemy_type == 1:
		velocity = type1movement(direction)
	elif enemy_type == 2:
		velocity = type2movement(direction)
	else: 
		velocity = type0movement(direction)
		
	velocity += get_separation_vector() * 100.0  # Increase to adjust the repelling force
	move_and_collide(velocity*_delta)

func take_damage(damage: float = 1):
	health -= damage
	#$Slime.play_hurt()
	if health <= 0:
		add_particle_simulation()
		emit_signal("on_death")
		queue_free()
		
func add_particle_simulation():
	var particle_scene = load("res://scenes/blood.tscn")
	for i in range(30):
		var particle_instance = particle_scene.instantiate()
		get_parent().add_child(particle_instance)
		particle_instance.global_position = global_position

func get_separation_vector() -> Vector2:
	var separation = Vector2.ZERO
	if parent_node.get_children().size() != 0:
		for enemy in parent_node.get_children():
		# Ensure the enemy is a valid instance of CharacterBody2D and not self
			if enemy != self and enemy is CharacterBody2D and is_instance_valid(enemy):
				if enemy.global_position.distance_to(global_position) < separation_distance:
				# Calculate the vector pointing away from the nearby enemy
					var repelling_force = global_position.direction_to(enemy.global_position).normalized()
					separation -= repelling_force  # Subtract to push away from other enemies
	return separation
