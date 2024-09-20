extends Node2D

var rng = RandomNumberGenerator.new()

func spawn_mob():
	var enemy_type = rng.randi_range(0, 10)
	var new_mob
	if enemy_type == 0:
		new_mob = preload("res://mob1.tscn").instantiate()
	elif enemy_type == 1:
		new_mob = preload("res://mob2.tscn").instantiate()
	else:
		new_mob = preload("res://mob2.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_deplete():
	%GameOverScreen.visible = true
	get_tree().paused = true
