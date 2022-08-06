extends Control

var active = false

func _ready():
	pass

func _physics_process(delta):
	if active == true:
		visible = true
	else:
		visible = false
