extends CharacterBody2D

var health = 20
var separation_distance = 100.0  # Minimum distance to maintain between enemies

signal on_death()
@onready var player = get_node("/root/main/player")
@onready var waveman = get_node("/root/main/WaveManager")
@onready var parent_node  # This will reference the parent node containing all enemies (other instances of this scene)
var timer
@onready var powerupman = get_node("/root/main/PowerupManager")
@export var dropRate: float = 0.1

func _ready():
	timer = Timer.new()
	timer.connect("timeout", Callable(self, "stop_moving"))
	connect("on_death", waveman._on_mob_death)
	
	# Reference the parent node that holds all enemy instances
	parent_node = get_parent()

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	var velocity = direction * 700.0
	
	# Adjust velocity to avoid nearby enemies
	velocity += get_separation_vector() * 100.0  # Increase to adjust the repelling force
	
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

func take_damage(damage: float = 1):
	health -= damage
	#$Slime.play_hurt()
	if health <= 0:
		var rand_var: float = randf()
		if rand_var <= dropRate:
			powerupman.spawn_random_pickup(position)
		add_particle_simulation()
		emit_signal("on_death")
		queue_free()

func add_particle_simulation():
	var particle_scene = load("res://scenes/blood.tscn")
	for i in range(15):
		var particle_instance = particle_scene.instantiate()
		get_parent().add_child(particle_instance)
		particle_instance.global_position = global_position
