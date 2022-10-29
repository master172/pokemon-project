extends HBoxContainer

var toggled = false

signal save

func _ready():
	pass

func get_pressed():
	return toggled

func set_pressed(value):
	toggled = value
	OS.set_use_vsync(toggled)
	self.get_child(1).pressed = toggled

func _active():
	self.get_child(0).modulate = Color("00bdff")

func _deactivate():
	self.get_child(0).modulate = Color("ffffff")

func _toggle():
	toggled = not toggled
	if toggled == true:
		OS.set_use_vsync(true)
		self.get_child(1).pressed = true
	elif toggled == false:
		OS.set_use_vsync(false)
		self.get_child(1).pressed = false
	emit_signal("save")