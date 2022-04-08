extends Node

var current_loaded_pokemon


func _change_parent():
	self.get_child(0).change_parent()
