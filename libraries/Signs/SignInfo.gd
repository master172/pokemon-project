extends StaticBody2D

var player

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

onready var dialog = Dialog.instance()

export(Array) var first_dialog

func _ready():
	pass

func _Start_dialog():

	dialog.text_to_diaplay = first_dialog
	Utils.get_dialog_layer().add_child(dialog)

		
	dialog.connect("Dialog_ended",self,"_finish_dialog")


func _finish_dialog():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false
		player = null
	dialog = null
