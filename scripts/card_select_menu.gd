extends Node

signal card_selected(uid: int)

func _on_continue_button_pressed() -> void:
	%CardSelect.visible = false
	emit_signal("card_selected", $ColorRect/Card_Box.currentlySelected)

func _on_visibility_changed() -> void:
	if %CardSelect.visible:
		%PowerupManager.generate_cards()
