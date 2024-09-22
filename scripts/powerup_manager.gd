extends Node

class_name Powerup

@onready var Player = $"/root/main/player"
@export var Powerups: Array[PowerupBase]
var pickupInst = preload("res://scenes/pickup.tscn")

func execute_powerup() -> void:
	assert(false, "Implement this in child class")
	
func spawn_random_pickup(pos: Vector2):
	var chosenOne: PowerupBase = Powerups.pick_random()
	var inst = pickupInst.instantiate()
	inst.get_child(2).texture = chosenOne.icon
	inst.callBackFunction = Callable(%PowerupManager.get_child(chosenOne.ind), "execute")
	inst.global_position = pos
	get_parent().add_child(inst)

func generate_cards():
	Powerups.shuffle()
	$"../CardSelect/ColorRect/Card_Box".set_cards(Powerups[0], Powerups[1], Powerups[2])
