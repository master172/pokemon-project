extends TextureRect

var pokemon

var Pokemon_to_set
onready var Sprite = $Sprite
onready var Name = $Name
onready var Level = $Level
onready var selector = $Selector

var selected = false

var num :int

func _ready():
	$Timer.start()


func _physics_process(_delta):
	if selected == true:
		selector.color = Color("00ff4c")
	else:
		selector.color = Color("00000000")


func _on_Timer_timeout():
	if Pokemon_to_set != null:
		pokemon = Pokemon_to_set
		Sprite.texture = pokemon.sprite
		Name.text = pokemon.Name
		Level.text = String(pokemon.level)
