extends Control

var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "change_scene"))
	timer.start(12.0)
	$AnimationPlayer.play("intro")
	RainMusic.play_music()

func change_scene():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
