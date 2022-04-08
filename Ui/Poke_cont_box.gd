extends Control


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
	self.queue_free()

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
					controller.first_slot = null
					controller.second_slot = null
					self.controller.poke_cont_end()
			Options.Switch:
				self.controller.pre_switch()
	elif event.is_action_pressed("decline"):
		if self.controller != null:
			controller.first_slot = null
			controller.second_slot = null
			self.controller.poke_cont_end()
