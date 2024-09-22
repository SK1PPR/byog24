extends Node

class_name Powerup

@onready var Player = $"/root/main/player"
@export var Powerups: Array[PowerupBase]
var pickupInst = preload("res://scenes/pickup.tscn")

func execute_powerup() -> void:
	assert(false, "Implement this in child class")
	
func spawn_random_pickup(pos: Vector2):
	print('Random pickup lmfaooo: ', pos)
	var chosenOne: PowerupBase = Powerups.pick_random()
	var inst = pickupInst.instantiate()
	inst.get_child(2).texture = chosenOne.icon
	inst.callBackFunction = Callable(%PowerupManager.get_child(chosenOne.ind), "execute")
	inst.global_position = pos
	get_parent().add_child(inst)
