extends AnimatedSprite

func _ready():
	visible = false
	playing = false


func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	playing = true


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	playing = false
