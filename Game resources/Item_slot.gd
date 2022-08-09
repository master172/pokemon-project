extends TextureRect

var item

onready var Sprite = $item
onready var count = $Count
onready var description = $Label

func _physics_process(_delta):
	if item != null:

		Sprite.texture = item.sprite
		count.text = String(item.count)
		description.text = item.Description
