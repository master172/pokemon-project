extends Control


func _ready():
	pass


func _get_poke_sprite():
	return get_node("PokeBackground/PokeSprite")

func _get_poke_name():
	return get_node("Name")

func _get_poke_meter():
	return get_node("TextureProgress")

func _get_poke_heart():
	return get_node("AnimatedSprite")