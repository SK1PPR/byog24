extends Node

signal card_pressed(card_number: int)

@export var border: Resource
@export var pic: Resource
@export var labelText: String
@export var uid: int
@export var selectBorder: Resource

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if $Border.inside(event.position):
			emit_signal("card_pressed", uid)
			
func set_vals(r: PowerupBase):
	$VBoxContainer/Image.texture = r.icon
	$VBoxContainer/Panel/Label.text = r.desc
