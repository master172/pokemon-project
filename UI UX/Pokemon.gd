extends Control

onready var grid_container = $ScrollContainer/GridContainer

const Pokemon_card = preload("res://UI UX/Pokemon1_card.tscn")

var number :int = 0

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	for i in PlayerPokemon.pc_pokemon:
		var pokemon_card = Pokemon_card.instance()
		pokemon_card.num = number
		number += 1
		pokemon_card.Pokemon_to_set = i
		grid_container.add_child(pokemon_card)
