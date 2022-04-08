extends AnimatedSprite


func _ready():
	frame = 0
	playing = true


func _on_AnimatedSprite_animation_finished():
	queue_free()
