extends TextureRect

export var item : PackedScene
onready var Item

onready var Sprite = $item
onready var count = $Count
onready var description = $Label

func _ready():
	if item != null:
		Item = item.instance()
func _physics_process(_delta):
	if Item != null:
		Sprite.texture = Item.sprite
		count.text = String(Item.count)
		description.text = Item.Description
