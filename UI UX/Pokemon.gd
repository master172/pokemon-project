extends Control

onready var pokemon_1 = $Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Left/Pokemon_back_1/Fore_ground/Sprite
onready var pokemon_2 = $Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Left/Pokemon_back_2/Fore_ground2/Sprite2
onready var pokemon_3 = $Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Left/Pokemon_back_3/Fore_ground3/Sprite3
onready var pokemon_4 = $Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Right/Pokemon_back_4/Fore_ground4/Sprite4
onready var pokemon_5 = $Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Right/Pokemon_back_5/Fore_ground5/Sprite5
onready var pokemon_6 = $Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Right/Pokemon_back_6/Fore_ground6/Sprite6

onready var grid_container = $ScrollContainer/GridContainer

const Pokemon_card = preload("res://UI UX/Pokemon1_card.tscn")

var number :int = 0


func _physics_process(_delta):
	yield(get_tree().create_timer(0.2),"timeout")
	pokemon_1.texture = PlayerPokemon.first_pokemon.sprite
	pokemon_2.texture = PlayerPokemon.second_pokemon.sprite
	pokemon_3.texture = PlayerPokemon.third_pokemon.sprite
	pokemon_4.texture = PlayerPokemon.fourth_pokemon.sprite
	pokemon_5.texture = PlayerPokemon.fifth_pokemon.sprite
	pokemon_6.texture = PlayerPokemon.sixth_pokemon.sprite

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	for i in PlayerPokemon.pc_pokemon:
		var pokemon_card = Pokemon_card.instance()
		pokemon_card.num = number
		number += 1
		pokemon_card.Pokemon_to_set = i
		grid_container.add_child(pokemon_card)
	
