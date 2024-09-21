extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/Game/Player")

var time_elapsed = 0.0 

func _ready():
	$Slime.play_walk()

func type0movement(direction, delta):
	var zigzag_amplitude = 200.0
	var zigzag_frequency = 20.0
	var zigzag_offset = sin(time_elapsed * zigzag_frequency) * zigzag_amplitude

	direction.x += zigzag_offset * delta
	return direction * 600.0

func _physics_process(delta):
	time_elapsed += delta
	var direction = global_position.direction_to(player.global_position)
	velocity = type0movement(direction, delta)
	move_and_slide()

func take_damage():
	health -= 1
	$Slime.play_hurt()
	if health == 0:
		queue_free()
		
		const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
