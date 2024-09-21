extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/main/player")
@onready var waveman = get_node("/root/main/WaveManager")
signal on_death()

var rng = RandomNumberGenerator.new()

func _ready():
	connect("on_death", waveman._on_mob_death)

func type0movement(direction):
	return direction* 300.0

func type1movement(direction):
	direction[1] = direction[1]*5000.0
	direction[0] = direction[0]*10000.0
	return direction

func type2movement(direction):
	direction[1] = direction[1]*10000.0
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
	move_and_slide()

func take_damage():
	health -= 1
	#$Slime.play_hurt()
	if health == 0:
		emit_signal("on_death")
		queue_free()
		
		
