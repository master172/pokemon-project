extends Control


func _ready():
	pass


func _on_LineEdit_mouse_entered():
	print("mouse entered")



func _on_LineEdit_modal_closed():
	print("modal closed")


func _on_LineEdit_focus_entered():
	print("focus entered")
