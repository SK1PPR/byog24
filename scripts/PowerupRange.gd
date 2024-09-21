extends Area2D

func _on_poison_aura_used(dps: float) -> void:
	for i in range(20):
		var enemies = get_overlapping_bodies()
		if enemies.size() > 0:
			for enemy in enemies:
				enemy.take_damage(dps)
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.start()
		await timer.timeout
		timer.queue_free()
