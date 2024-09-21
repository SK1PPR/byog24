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
	
var current_wave: int = 0
const WAVE_GAP: int = 7
	
func _ready() -> void:
	$WaveManager.start_wave(current_wave)


#func _on_player_health_deplete():
	#%GameOverScreen.visible = true
	#get_tree().paused = true


func _on_wave_ended() -> void:
	print("Wave Ended")
	current_wave += 1
	$InterWaveTimer.wait_time = WAVE_GAP
	$InterWaveTimer.start()
		
func _wave_timeout_over() -> void:
	if $WaveManager.waves.size() > current_wave:
		#$PowerupManager/PoisonAura.execute()
		$WaveManager.start_wave(current_wave)
	else:
		print("Ended")
