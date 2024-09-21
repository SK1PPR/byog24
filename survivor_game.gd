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
const WAVE_GAP: int = 8
	
func _ready() -> void:
	$WaveSpawnText.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = WAVE_GAP
	timer.one_shot = true
	timer.start() 
	await timer.timeout
	timer.queue_free()
	$WaveManager.start_wave(current_wave)


func _on_player_health_deplete():
	%GameOverScreen.visible = true
	get_tree().paused = true

func _on_wave_ended() -> void:
	%CardSelect.visible = true


func _on_card_selected(uid: int) -> void:
	print("Powerup ", uid, " was selected")
	print("Spawning new wave")
	current_wave += 1
	$WaveSpawnText/Label.text = "Wave " + str(current_wave + 1)
	$WaveSpawnText.visible = true
	$InterWaveTimer.wait_time = WAVE_GAP
	$InterWaveTimer.start()
		
func _wave_timeout_over() -> void:
	if $WaveManager.waves.size() > current_wave:
		$PowerupManager/PoisonAura.execute()
		$WaveManager.start_wave(current_wave)
	else:
		print("Ended")
