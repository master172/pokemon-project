extends StaticBody2D

var player

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

#current_question
var current_question = 0
var current_to_ask : Array
#first dialog layer
var first_dialog_emmited = false
var first_dialog :Array = ["Unknown_box: Hi Ash this is Godot! What you dont know about me","Unknown_box:-- no worries lets take a dive in",
"Unknown_box: I am the Godot icon let me help you explore this world","Godot_icon: First let me ask you a question","Godot_icon: Have you heard about godot?"
,1,"I am an  open source game development engine","This world is also built by one of my users named sumant","Ash: What do we live in a simulation",1,
"Godot_box: Godot is an awesome game engine make sure to try it out one day",0]

#to_repeat_dialog
var to_repeat_dialog
#first question
var first_question :Array = [["yes","Godot_box: Very well","Godot_box: I am glad to hear that",1],["no"," Godot_box: No worries","Godot_box: I will tell you about us",1]]

#second_question
var second_question :Array = [["yes","Godot_box: We do"," Godot_box: It might sound unbeliveable but its true",1],["no","Godot_box: Just kidding","Godot_box: I was just promoting myself",
	"Godot_box: in mind:-- This kid might break down to the truth",1]]
var dialog = Dialog.instance()

func _ready():
	current_to_ask = first_question


func _Start_dialog():
	
	if first_dialog_emmited == false:
		to_repeat_dialog = first_dialog
		dialog.text_to_diaplay = first_dialog
		dialog.choices = first_question
		first_dialog_emmited = true
	else:
		dialog.text_to_diaplay = first_dialog
		dialog.choices = first_question

	Utils.get_dialog_layer().add_child(dialog)
	dialog.connect("Dialog_ended",self,"_finish_dialog")
	dialog.connect("choice_ended",self,"_change_question")

func _finish_dialog():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false

func _change_question():
	current_question += 1
	if current_question == 0:
		current_to_ask = first_question
		dialog.choices = current_to_ask
	elif current_question == 1:
		current_to_ask = second_question
		dialog.choices = current_to_ask