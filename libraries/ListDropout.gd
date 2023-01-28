extends Control

var currentItem

var inactiveColor = Color()
var activeColor = Color("00e7ff")

func _ready():
	if currentItem != null:
		get_child(1).text = currentItem.instance().Name

func _active():
	get_child(0).color = activeColor

func _inactive():
	get_child(0).color = inactiveColor

func _change_quantity(quantity):
	get_child(2).text = String(quantity)

func _close_quantiy():
	get_child(2).text = ""