extends Control

func _ready():
	RainMusic.start_bg()
	RainMusic.lower_volume()
	$Options.visible = false

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_options_pressed():
	$Lightning.visible = false
	$Options.visible = true


func _on_exit_pressed():
	get_tree().quit()


func _on_back_pressed():
	$Lightning.visible = true
	$Options.visible = false
