extends Area2D

var travelled_distance = 0
const SPEED = 1000
const RANGE = 1200
var damage = 10

func _physics_process(delta):
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()
	


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(damage)
