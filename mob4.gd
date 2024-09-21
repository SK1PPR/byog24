extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/Game/Player")

func _ready():
	$Slime.play_walk()

func type0movement(direction):
	return direction * 300.0

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = type0movement(direction)
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
