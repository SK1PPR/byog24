extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/main/player")
var timer

func _ready():
	timer = Timer.new()
	timer.connect("timeout", Callable(self, "stop_moving"))

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 200.0
	move_and_slide()

func take_damage():
	health -= 1
	#$Slime.play_hurt()
	if health == 0:
		queue_free()
		
		#const SMOKE = preload("res://smoke_explosion/smoke_explosion.tscn")
		#var smoke = SMOKE.instantiate()
		#get_parent().add_child(smoke)
		#smoke.global_position = global_position
		
