extends Powerup

signal first_aid_used(inc: int)
const HEALTH_INC = 50

func execute() -> void:
	emit_signal("first_aid_used", HEALTH_INC)
