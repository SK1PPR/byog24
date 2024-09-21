extends Node

signal poison_aura_used(dps: float)
@export var damage: float = 0.5

func execute() -> void:
	emit_signal("poison_aura_used", damage)
