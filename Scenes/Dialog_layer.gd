extends Node2D

signal child_removed

var had_child = false
var has_child = true

func _ready():
	pass

func _physics_process(_delta):
	_had_child()

func _had_child():
	if self.get_child_count() > 0:
		has_child = true
		had_child = false
	
	if has_child == true and self.get_child_count() > 0:
		pass
	elif has_child == true and self.get_child_count() == 0:
		had_child = true
		has_child = false
		emit_signal("child_removed")