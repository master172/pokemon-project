extends TextureRect

var active = false

func _ready():
	pass

func _physics_process(_delta):
	if active == true:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0