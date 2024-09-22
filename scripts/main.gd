extends Node2D
	
var current_wave: int = 0
@export var WAVE_GAP: int = 8
@export var interval: float = 3.0
@export var dialogue_interval: float = 1.5
@export var dialogue_path: Array[NodePath]
var j = 0
	
func _ready():
	%DialogueLayerBeginning.visible = true
	%DialogueLayerBeginning.print_dialogue()

func _start_waves():
	$WaveSpawnText.visible = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = WAVE_GAP
	timer.one_shot = true
	timer.start() 
	await timer.timeout
	timer.queue_free()
	$WaveManager.start_wave(current_wave)

func _on_player_health_deplete():
	%GameOverScreen.visible = true
	get_tree().paused = true

func _on_wave_ended() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = interval
	timer.one_shot = true
	if current_wave % 2 != 0:
		timer.wait_time = dialogue_interval
	timer.start()
	await timer.timeout
	timer.queue_free()
	if current_wave % 2 != 0:
		%DialogueLayerBeginning.visible = true
		%DialogueLayerBeginning.print_dialogue()
	else:
		%CardSelect.visible = true


func _on_card_selected(uid: int) -> void:
	print("Powerup ", uid, " was selected")
	print("Spawning new wave")
	current_wave += 1
	$WaveSpawnText/Label.text = "Wave " + str(current_wave + 1)
	$WaveSpawnText.visible = true
	$InterWaveTimer.wait_time = WAVE_GAP
	$InterWaveTimer.start()
		
func _wave_timeout_over() -> void:
	if $WaveManager.waves.size() > current_wave:
		$PowerupManager/PoisonAura.execute()
		$WaveManager.start_wave(current_wave)
	else:
		print("Ended")



func _on_dialogue_layer_beginning_dialogue_finished():
	if current_wave == 0:
		_start_waves()
	else:
		%CardSelect.visible = true
