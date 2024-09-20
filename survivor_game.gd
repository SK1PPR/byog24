extends Node2D

#func spawn_mob():
	#var new_mob = preload("res://mob.tscn").instantiate()
	#%PathFollow2D.progress_ratio = randf()
	#new_mob.global_position = %PathFollow2D.global_position
	#add_child(new_mob)
#
#
#func _on_timer_timeout():
	#spawn_mob()
	
func _ready() -> void:
	$WaveManager.start_wave(0)


func _on_player_health_deplete():
	%GameOverScreen.visible = true
	get_tree().paused = true
