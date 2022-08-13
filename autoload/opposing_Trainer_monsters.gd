extends Node

var targets : int = 1

var pokemon 
var second_pokemon
var third_pokemon

var opposing_pokemon 

var num_active_pokemon = []

func _ready():
	pass

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_remove_children()

func _remove_children():
	for child in self.get_children():
		child.queue_free()

func _change_parent():
	self.get_child(0).change_parent()

func _attack():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		if self.pokemon != null:
			pokemon._wild_battle()