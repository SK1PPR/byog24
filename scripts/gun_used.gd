extends Node

signal gun_used(id: int)
@export var gunId: int

func execute() -> void:
	emit_signal("gun_used", gunId)
