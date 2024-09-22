extends CharacterBody2D

var health = 40
var separation_distance = 100.0  # Minimum distance to maintain between enemies

var time_elapsed = 0.0 

signal on_death()
@onready var player = get_node("/root/main/player")
@onready var waveman = get_node("/root/main/WaveManager")
@onready var parent_node  # This will reference the parent node containing all enemies (other instances of this scene)
var timer

func type0movement(direction, delta):
	var zigzag_amplitude = 150.0
	var zigzag_frequency = 10.0
	var zigzag_offset = sin(time_elapsed * zigzag_frequency) * zigzag_amplitude

	direction.x += zigzag_offset * delta
	return direction * 600.0
	
func _ready():
	timer = Timer.new()
	timer.connect("timeout", Callable(self, "stop_moving"))
	connect("on_death", waveman._on_mob_death)
	
	# Reference the parent node that holds all enemy instances
	parent_node = get_parent()

func _physics_process(_delta):
	time_elapsed += _delta
	var direction = global_position.direction_to(player.global_position)
	velocity = type0movement(direction, _delta)
	move_and_collide(velocity * _delta)

# Calculate the separation vector based on other CharacterBody2D instances (enemies)
func get_separation_vector() -> Vector2:
	var separation = Vector2.ZERO
	for enemy in parent_node.get_children():
		# Ensure the enemy is a valid instance of CharacterBody2D and not self
		if enemy != self and enemy is CharacterBody2D and is_instance_valid(enemy):
			if enemy.global_position.distance_to(global_position) < separation_distance:
				# Calculate the vector pointing away from the nearby enemy
				var repelling_force = global_position.direction_to(enemy.global_position).normalized()
				separation -= repelling_force  # Subtract to push away from other enemies
	return separation

func add_particle_simulation():
	var particle_scene = load("res://scenes/blood.tscn")
	for i in range(30):
		var particle_instance = particle_scene.instantiate()
		get_parent().add_child(particle_instance)
		particle_instance.global_position = global_position


func take_damage(damage: float = 1):
	health -= damage
	#$Slime.play_hurt()
	if health <= 0:
		add_particle_simulation()	
		emit_signal("on_death")
		queue_free()
