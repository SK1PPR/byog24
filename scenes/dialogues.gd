extends CanvasLayer


@export var dialogues: Array[Comment]
@export var devil: Color
@export var ninja: Color

signal dialogue_finished

var printing = true
@export var text_rate: float = 5
var current_index = 0

func _ready():
	print_dialogue()

func print_dialogue():
	%Printer.text = dialogues[current_index].line
	%Printer.visible_ratio = 0
	if dialogues[current_index].speaker == 0:
		%Printer.add_theme_color_override("default_color", devil)
	else:
		%Printer.add_theme_color_override("default_color", ninja)
	
func _process(delta):
	
	if %Printer.visible_ratio < 1:
		%Printer.visible_ratio += (text_rate * delta)
	elif Input.is_action_just_released("next_dialogue"):
		current_index += 1
		if current_index >= dialogues.size():
			visible = false
			dialogue_finished.emit()
			queue_free()
		else:
			print_dialogue()
		
