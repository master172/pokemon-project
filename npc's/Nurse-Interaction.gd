extends Area2D

var player

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")
onready var dialog = Dialog.instance()

var dialog_functions = []

var greetings_dialog = ["Greetings, would you like to rest your pokemon",1,2,"",0]
var greetings_question = [["yes","very well please give us your pokemon for a few seconds",1],["no","very well, Please take care",1]]

var endings_dialog = ["We have healed your pokemon, Please take care"]

var set_choice = ""

func _ready():
	pass

func _Start_dialog():
	dialog = Dialog.instance()
	dialog.text_to_diaplay = greetings_dialog
	dialog.choices = greetings_question
	Utils.get_dialog_layer().add_child(dialog)
		
	dialog.connect("Dialog_ended",self,"_finish_dialog")
	dialog.connect("_choice_number",self,"_set_choice")
	dialog.connect("_function",self,"_function_manager")
			

func _set_choice(choice):
	if choice == 0:
		set_choice = "yes"
	elif choice == 1:
		set_choice = "no"
	dialog_functions = ["Choice",[self.set_choice]]
	dialog.functions = dialog_functions

func _finish_dialog():
	greetings_dialog =["Greetings, would you like to rest your pokemon",1,2,"",0]
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false
		player = null
	dialog = null

func _function_manager(function):
	if function[0] == "Choice":
		choice_results(function[1][0])

func choice_results(choice):
	if choice == "yes":
		if player != null:
			player.interacting = true
			player.is_talking = true
		_ending_dialog()
	else:
		print("ok")
		_ending_dialog()

func _ending_dialog():
	if set_choice == "yes":
		if dialog != null:
			greetings_dialog[3] = endings_dialog[0]
	elif set_choice == "no":
		if dialog != null:
			greetings_dialog.remove(3)
	dialog.text_to_diaplay = greetings_dialog