extends CharacterBody2D

signal health_deplete

var health = 100.0
const DAMAGE_RATE = 5.0

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() != 0:
		$HappyBoo.play_walk_animation();
	else :
		$HappyBoo.play_idle_animation();
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_deplete.emit()
			


func _on_first_aid_used(inc: int) -> void:
	health += inc
