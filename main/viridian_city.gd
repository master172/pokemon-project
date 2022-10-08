extends YSort


func _ready():
	visible = false


func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	set_physics_process(true)
	set_process(true)


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	set_physics_process(false)
	set_process(false)
