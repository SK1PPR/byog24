extends Powerup

signal shield_used(shieldTime: int, damageFactor: float)
@export var shieldTime: int = 40
@export var damageFactor: float = 0.1

func execute() -> void:
	emit_signal("shield_used", shieldTime, damageFactor)
	
