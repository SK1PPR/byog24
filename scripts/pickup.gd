extends Area2D

@export var callBackFunction: Callable
	
func _on_body_entered(body: Node2D) -> void:
	callBackFunction.call()
	queue_free()
