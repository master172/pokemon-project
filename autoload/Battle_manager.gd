extends Node

enum types_of_battle {Wild,Trainer}
var type_of_battle

var turns:int

var catched = false
var fainted =  false

var in_battle = false

func _physics_process(delta):
	if OpposingTrainerMonsters.pokemon != null:
		PlayerPokemon.opposing_pokemon = OpposingTrainerMonsters.pokemon
	else:
		PlayerPokemon.opposing_pokemon = null
	
	if OpposingTrainerMonsters.pokemon != null:
		if PlayerPokemon.current_pokemon != null and OpposingTrainerMonsters.pokemon.opposing_pokemon != PlayerPokemon.current_pokemon:
			OpposingTrainerMonsters.opposing_pokemon = PlayerPokemon.current_pokemon
			OpposingTrainerMonsters.pokemon._calc_weak_and_res()
	else:
		OpposingTrainerMonsters.opposing_pokemon = null