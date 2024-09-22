extends CanvasLayer


@export var dialogues: Array[Dialogue]
@export var devil: Color
@export var ninja: Color
@export var newbie: Color

signal dialogue_finished

var printing = true
@export var text_rate: float = 5
var line_index = 0
var dialogue_index = 0

func print_dialogue():
	if dialogue_index < dialogues.size():
		$Panel/Printer.text = dialogues[dialogue_index].lines[line_index].line
		$Panel/Printer.visible_ratio = 0
		if dialogues[dialogue_index].lines[line_index].speaker == 0:
			$Panel/Printer.add_theme_color_override("default_color", devil)
		elif dialogues[dialogue_index].lines[line_index].speaker == 1:
			$Panel/Printer.add_theme_color_override("default_color", ninja)
		else:
			$Panel/Printer.add_theme_color_override("default_color", newbie)
			
	else:
		pass #add logic for end screen
	
func _process(delta):
	if $Panel/Printer.visible_ratio < 1:
		$Panel/Printer.visible_ratio += (text_rate * delta)
	elif Input.is_action_just_released("next_dialogue") && visible:
		line_index += 1
		if line_index >= dialogues[dialogue_index].lines.size():
			visible = false
			dialogue_index += 1
			line_index = 0
			dialogue_finished.emit()
		else:
			print_dialogue()
		
