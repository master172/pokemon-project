extends Control

onready var PokeRow1 = $PokemonContainer/Row0
onready var PokeRow2 = $PokemonContainer/Row1

func _change_visibility():
	visible = not visible
	if visible == true:
		_display()

func _display():
	if PlayerPokemon.first_pokemon != null:
		PokeRow1.get_child(0).get_child(0).get_child(0).texture = PlayerPokemon.first_pokemon.sprite
	if PlayerPokemon.second_pokemon != null:
		PokeRow1.get_child(1).get_child(0).get_child(0).texture = PlayerPokemon.second_pokemon.sprite
	if PlayerPokemon.third_pokemon != null:
		PokeRow1.get_child(2).get_child(0).get_child(0).texture = PlayerPokemon.third_pokemon.sprite
	if PlayerPokemon.fourth_pokemon != null:
		PokeRow2.get_child(0).get_child(0).get_child(0).texture = PlayerPokemon.fourth_pokemon.sprite
	if PlayerPokemon.fifth_pokemon != null:
		PokeRow2.get_child(1).get_child(0).get_child(0).texture = PlayerPokemon. fifth_pokemon.sprite
	if PlayerPokemon.sixth_pokemon != null:
		PokeRow2.get_child(2).get_child(0).get_child(0).texture = PlayerPokemon.sixth_pokemon.sprite
	
func _input(event):
	if event.is_action_pressed("decline"):
		if visible == true:
			Utils.get_menu()._Undisplay_Player_card()