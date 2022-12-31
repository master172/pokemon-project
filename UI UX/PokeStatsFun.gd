extends Control

var current_selected :int = 0
var max_selecctable :int = 5

var pokemon_array = []

onready var Pokemon_card_0 = $PokeCardLeft
onready var pokemon_card_1 = $PokeCardMain
onready var pokemon_card_2 = $PokeCardRight

onready var Card_arr = [Pokemon_card_0, pokemon_card_1, pokemon_card_2]

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")

	_append_to_pokemon_arr(PlayerPokemon.first_pokemon)
	_append_to_pokemon_arr(PlayerPokemon.second_pokemon)
	_append_to_pokemon_arr(PlayerPokemon.third_pokemon)
	_append_to_pokemon_arr(PlayerPokemon.fourth_pokemon)
	_append_to_pokemon_arr(PlayerPokemon.fifth_pokemon)
	_append_to_pokemon_arr(PlayerPokemon.sixth_pokemon)

	if current_selected == 0:
		if PlayerPokemon.first_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[0].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[0].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.second_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[1].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[1].Name	
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.sixth_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[5].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[5].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 1:
		if PlayerPokemon.second_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[1].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[1].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.third_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[2].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[2].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.first_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[0].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[0].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 2:
		if PlayerPokemon.third_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[2].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[2].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[3].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[3].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.second_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[1].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[1].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 3:
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[3].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[3].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.fifth_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[4].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[4].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.third_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[2].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[2].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 4:
		if PlayerPokemon.fifth_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[4].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[4].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.sixth_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[5].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[5].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[3].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[3].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 5:
		if PlayerPokemon.sixth_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[5].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[5].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.first_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[0].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[0].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[4].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[4].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

func _append_to_pokemon_arr(pokemon):
	if pokemon == null:
		pokemon_array.append(int(0))

	else:
		pokemon_array.append(pokemon)

	return



func _input(event):
	if event.is_action_pressed("A"):
		if current_selected == 0:
			current_selected = max_selecctable
		else:
			current_selected -= 1
		print(current_selected)
	
	elif event.is_action_pressed("D"):
		if current_selected == max_selecctable:
			current_selected = 0
		else:
			current_selected += 1
		print(current_selected)

	if current_selected == 0:
		if PlayerPokemon.first_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[0].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[0].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.second_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[1].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[1].Name	
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.sixth_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[5].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[5].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 1:
		if PlayerPokemon.second_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[1].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[1].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.third_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[2].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[2].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.first_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[0].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[0].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 2:
		if PlayerPokemon.third_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[2].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[2].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[3].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[3].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.second_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[1].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[1].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 3:
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[3].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[3].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.fifth_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[4].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[4].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.third_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[2].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[2].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 4:
		if PlayerPokemon.fifth_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[4].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[4].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.sixth_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[5].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[5].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[3].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[3].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""

	elif current_selected == 5:
		if PlayerPokemon.sixth_pokemon != null:
			Card_arr[1]._get_poke_sprite().texture = pokemon_array[5].sprite
			Card_arr[1]._get_poke_name().text = pokemon_array[5].Name
		else:
			Card_arr[1]._get_poke_sprite().texture = null
			Card_arr[1]._get_poke_name().text = ""
		
		if PlayerPokemon.first_pokemon != null:
			Card_arr[2]._get_poke_sprite().texture = pokemon_array[0].sprite
			Card_arr[2]._get_poke_name().text = pokemon_array[0].Name
		else:
			Card_arr[2]._get_poke_sprite().texture = null
			Card_arr[2]._get_poke_name().text = ""
		
		if PlayerPokemon.fourth_pokemon != null:
			Card_arr[0]._get_poke_sprite().texture = pokemon_array[4].sprite
			Card_arr[0]._get_poke_name().text = pokemon_array[4].Name
		else:
			Card_arr[0]._get_poke_sprite().texture = null
			Card_arr[0]._get_poke_name().text = ""
