extends Node

@onready var c0 = $Card
@onready var c1 = $Card3
@onready var c2 = $Card2
var currentlySelected = 0

func _card_clicked(uid: int):
	currentlySelected = uid
	var bord0 = c0.get_child(0)
	bord0.texture = c0.border
	var bord1 = c1.get_child(0)
	bord1.texture = c1.border
	var bord2 = c2.get_child(0)
	bord2.texture = c2.border
	if uid == 0:
		bord0.texture = c0.selectBorder
	elif  uid == 1:
		bord1.texture = c1.selectBorder
	else:
		bord2.texture = c2.selectBorder
	
func set_cards(r0: PowerupBase, r1: PowerupBase, r2: PowerupBase):
	get_child(0).set_vals(r0)
	get_child(1).set_vals(r1)
	get_child(2).set_vals(r2)
