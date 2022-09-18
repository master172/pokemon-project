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

var pokemon_set = false

func _physics_process(_delta):
	if pokemon_set == false:
		yield(get_tree().create_timer(0.2),"timeout")
		pokemon_set = true
		if PlayerPokemon.first_pokemon !=  null:
			pokemon_1.texture = PlayerPokemon.first_pokemon.sprite
		else:
			pokemon_1.texture =  null
		if PlayerPokemon.second_pokemon !=  null:
			pokemon_2.texture = PlayerPokemon.second_pokemon.sprite
		else:
			pokemon_2.texture =  null
		if PlayerPokemon.third_pokemon !=  null:
			pokemon_3.texture = PlayerPokemon.third_pokemon.sprite
		else:
			pokemon_3.texture =  null
		
		if PlayerPokemon.fourth_pokemon !=  null:
			pokemon_4.texture = PlayerPokemon.fourth_pokemon.sprite
		else:	
			pokemon_4.texture =  null
		if PlayerPokemon.fifth_pokemon !=  null:
			pokemon_5.texture = PlayerPokemon.fifth_pokemon.sprite
		else:	
			pokemon_5.texture =  null
		if PlayerPokemon.sixth_pokemon !=  null:
			pokemon_6.texture = PlayerPokemon.sixth_pokemon.sprite
		else:	
			pokemon_6.texture =  null
	else:
		if PlayerPokemon.first_pokemon !=  null:
			pokemon_1.texture = PlayerPokemon.first_pokemon.sprite
		else:
			pokemon_1.texture =  null
		if PlayerPokemon.second_pokemon !=  null:
			pokemon_2.texture = PlayerPokemon.second_pokemon.sprite
		else:
			pokemon_2.texture =  null
		if PlayerPokemon.third_pokemon !=  null:
			pokemon_3.texture = PlayerPokemon.third_pokemon.sprite
		else:
			pokemon_3.texture =  null
		
		if PlayerPokemon.fourth_pokemon !=  null:
			pokemon_4.texture = PlayerPokemon.fourth_pokemon.sprite
		else:	
			pokemon_4.texture =  null
		if PlayerPokemon.fifth_pokemon !=  null:
			pokemon_5.texture = PlayerPokemon.fifth_pokemon.sprite
		else:	
			pokemon_5.texture =  null
		if PlayerPokemon.sixth_pokemon !=  null:
			pokemon_6.texture = PlayerPokemon.sixth_pokemon.sprite
		else:	
			pokemon_6.texture =  null

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	for i in PlayerPokemon.pc_pokemon:
		var pokemon_card = Pokemon_card.instance()
		pokemon_card.Pokemon_to_set = i
		pokemon_card.name = "Pokemon_card" + String(grid_container.get_child_count())
		pokemon_card.num = number
		number += 1
		grid_container.add_child(pokemon_card)
	number = 0

func _update():
	for i in grid_container.get_children():
		i.queue_free()		
	for i in PlayerPokemon.pc_pokemon:
		var pokemon_card = Pokemon_card.instance()
		pokemon_card.Pokemon_to_set = i
		
		pokemon_card.name = "Pokemon_card" + String(grid_container.get_child_count())
		pokemon_card.num = number
		number += 1
		grid_container.add_child(pokemon_card)
	number = 0
	
