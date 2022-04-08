extends Node2D
enum Options { Yes, No }
var selected_option: int = Options.Yes

onready var yes = $Node2D/confirm
onready var no = $Node2D/decline

onready var options: Dictionary = {
	Options.Yes: yes,
	Options.No: no
}

func _ready():
	set_active_option()

func unset_active_option():
	options[selected_option].color = Color("1a1a1a")
	
func set_active_option():
	options[selected_option].color = Color("2c2c2c")


func _input(event):
	if event.is_action_pressed("ui_down"):
		unset_active_option()
		selected_option = (selected_option + 1) % 2
		set_active_option()
	elif event.is_action_pressed("ui_up"):
		unset_active_option()
		if selected_option == 0:
			selected_option = Options.No
		else:
			selected_option -= 1
		set_active_option()
	elif event.is_action_pressed("ui_left"):
		unset_active_option()
		selected_option = 0
		set_active_option()
	elif event.is_action_pressed("ui_right") and selected_option == Options.Yes:
		unset_active_option()
		selected_option = 1
		set_active_option()
	elif event.is_action_pressed("accept"):
		match selected_option: 
			Options.Yes: 
				Choices.choice = Choices.yes
				print(Choices.choice)
			Options.No:
				Choices.choice = Choices.no
				print(Choices.choice)
