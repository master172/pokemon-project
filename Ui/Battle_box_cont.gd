extends Control

var Pokemon_cont

enum Options { Summary, Switch, Item, Moves, Restore, Back }
var selected_option: int = Options.Summary

onready var Summary = $Node2D/Summary
onready var Switch = $Node2D/Switch
onready var Item = $Node2D/Item
onready var Moves = $Node2D/Moves
onready var Restore = $Node2D/Restore
onready var Back = $Node2D/Back

var controller

onready var options: Dictionary = {
	Options.Summary: Summary,
	Options.Switch: Switch,
	Options.Item: Item,
	Options.Moves: Moves,
	Options.Restore: Restore,
	Options.Back: Back
}

func _ready():
	set_active_option()

func unset_active_option():
	options[selected_option].color = Color("1a1a1a")
	
func set_active_option():
	options[selected_option].color = Color("2c2c2c")

func _kill():
	queue_free()

func _input(event):
	if event.is_action_pressed("ui_down"):
		unset_active_option()
		selected_option = (selected_option + 1) % 6
		set_active_option()
	elif event.is_action_pressed("ui_up"):
		unset_active_option()
		if selected_option == 0:
			selected_option = Options.Back
		else:
			selected_option -= 1
		set_active_option()
	elif event.is_action_pressed("ui_left"):
		unset_active_option()
		selected_option = 0
		set_active_option()
	elif event.is_action_pressed("ui_right") and selected_option == Options.Summary:
		unset_active_option()
		selected_option = 1
		set_active_option()
	elif event.is_action_pressed("accept"):
		match selected_option:
			Options.Back:
				if self.controller != null:
					_kill()
					
			Options.Switch:
				if self.Pokemon_cont != null:
					if Pokemon_cont.fainted == false:
						if BattleManager.in_battle == true:
							PlayerPokemon.current_pokemon = Pokemon_cont
							PlayerPokemon.current_pokemon._calc_weak_and_res()
							OpposingTrainerMonsters.pokemon._calc_weak_and_res()
							self.controller._kill()
						_kill()
					else:
						print("The pokemon has no energy to battle")
						_kill()
	elif event.is_action_pressed("decline"):
		if self.controller != null:
			_kill()
