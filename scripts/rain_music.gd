extends Node

#signal for bullet shots
signal bullet_shot

func play_music():
	$Rain.play()
	
func stop_music():
	$Rain.stop()

func lower_volume():
	$Rain.volume_db -= 5

func start_bg():
	$Metal.play()

func stop_rain():
	$CPUParticles2D.emitting = false
