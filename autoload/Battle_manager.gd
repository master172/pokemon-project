extends Node

enum types_of_battle {Wild,Trainer}
var type_of_battle

var turns:int

var catched = false
var fainted =  false

var in_battle = false

func _physics_process(_delta):
	if PlayerPokemon.current_pokemon != null:
		if OpposingTrainerMonsters.pokemon != null:
			PlayerPokemon.opposing_pokemon = OpposingTrainerMonsters.pokemon
		elif OpposingTrainerMonsters.pokemon == null:
			PlayerPokemon.opposing_pokemon = null
	else:
		PlayerPokemon.opposing_pokemon = null
	
	if OpposingTrainerMonsters.pokemon != null:
		if PlayerPokemon.current_pokemon != null:
			OpposingTrainerMonsters.opposing_pokemon = PlayerPokemon.current_pokemon
		if PlayerPokemon.current_pokemon == null:
			OpposingTrainerMonsters.opposing_pokemon = null
	else:
		OpposingTrainerMonsters.opposing_pokemon = null

func _ready():
	pass
