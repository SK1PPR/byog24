extends CanvasLayer

@export var waitTime: float = 5

func on_visiblilty_change():
	if %WaveSpawnText.visible:
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.wait_time = waitTime
		timer.one_shot = true
		timer.start()
		await timer.timeout
		timer.queue_free()
		%WaveSpawnText.visible = false
