extends Area2D

@onready var player = get_node("/root/Game/Player")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	look_at(direction*(-1))

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)


func _on_timer_timeout():
	shoot()
