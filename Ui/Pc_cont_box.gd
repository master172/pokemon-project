extends Control


enum Options { Summary, Withdraw, Item, Moves, Release, Back }
var selected_option: int = Options.Summary

onready var Summary = $Node2D/Summary
onready var Withdraw = $Node2D/Withdraw
onready var Item = $Node2D/Item
onready var Moves = $Node2D/Moves
onready var Release = $Node2D/Release
onready var Back = $Node2D/Back

var controller

var selected_pokemon

onready var options: Dictionary = {
	Options.Summary: Summary,
	Options.Withdraw: Withdraw,
	Options.Item: Item,
	Options.Moves: Moves,
	Options.Release: Release,
	Options.Back: Back
}

func _ready():
	set_active_option()

func unset_active_option():
	options[selected_option].color = Color("1a1a1a")
	
func set_active_option():
	options[selected_option].color = Color("2c2c2c")

func _kill():
	self.queue_free()
	self.controller.controller_active = false

func _input(event):
	if event.is_action_pressed("S"):
		unset_active_option()
		selected_option = (selected_option + 1) % 6
		set_active_option()
	elif event.is_action_pressed("W"):
		unset_active_option()
		if selected_option == 0:
			selected_option = Options.Back
		else:
			selected_option -= 1
		set_active_option()
	elif event.is_action_pressed("A"):
		unset_active_option()
		selected_option = 0
		set_active_option()
	elif event.is_action_pressed("D") and selected_option == Options.Summary:
		unset_active_option()
		selected_option = 1
		set_active_option()
	elif event.is_action_pressed("accept"):
		match selected_option:
			Options.Back:
				self.controller._remove_controller()
			Options.Withdraw:
				self.controller._withdraw(selected_pokemon)
				self.controller.state = self.controller.states.Party_navigation
				self.controller.current_selected = 0
				self.controller._remove_controller()

	elif event.is_action_pressed("decline"):
		if self.controller != null:
			pass
