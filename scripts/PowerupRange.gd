extends Area2D

func _on_poison_aura_used(dps: float) -> void:
	for i in range(20):
		# Get overlapping bodies (enemies)
		var enemies = get_overlapping_bodies()
		if enemies.size() > 0:
			for enemy in enemies:
				# Check if the enemy is not a StaticBody2D
				if not enemy.is_class("StaticBody2D"):
					enemy.take_damage(dps)
		
		# Create a timer for the delay between poison ticks
		var timer: Timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.5
		timer.one_shot = true
		timer.start()

		# Wait for the timer to finish
		await timer.timeout
		timer.queue_free()
