extends Control

var Pokemon_cont
var current_item
var current_pocket
var current_index

enum Options { Use,Give,Discard,Register,Free_space, Back }
var selected_option: int = Options.Use

onready var Use = $Node2D/Use
onready var Give = $Node2D/Give
onready var Discard = $Node2D/Discard
onready var Register = $Node2D/Register
onready var Free_space = $Node2D/Free_space
onready var Back = $Node2D/Back

var controller

onready var options: Dictionary = {
	Options.Use: Use,
	Options.Give: Give,
	Options.Discard: Discard,
	Options.Register: Register,
	Options.Free_space: Free_space,
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
	controller._reset()

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
	elif event.is_action_pressed("accept"):
		match selected_option:
			Options.Back:
				if self.controller != null:
					_kill()
					
			Options.Use:
				print("hi")
				if self.Pokemon_cont != null:
					if current_item != null:
						if current_item.has_method("_use"):
							current_item._use()
	elif event.is_action_pressed("decline"):
		if self.controller != null:
			_kill()
