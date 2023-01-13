extends Area2D

var player

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

onready var dialog = Dialog.instance()

var first_dialog = ["greetings what would you like me to help you with",1,0]
var options = [["buy",1],["sell",1],["cancel",1]]

signal start

func _ready():
	pass

func _Start_dialog():

	dialog = Dialog.instance()
	dialog.text_to_diaplay = first_dialog
	dialog.choices = self.options
	Utils.get_dialog_layer().add_child(dialog)

		
	dialog.connect("Dialog_ended",self,"_finish_dialog")
	dialog.connect("_choice_number",self,"_select_choice")

func _select_choice(choice):
	yield(self,"start")
	if choice == 0:	
		print("buy")
	elif choice == 1:
		print("sell")
	else:
		print("cancel")

func _finish_dialog():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false
		player = null
	dialog = null
	emit_signal("start")
	
