extends Node

enum types_of_battle {Wild,Trainer}
var type_of_battle

var multi_battle = false
var turns:int

var catched = false
var fainted =  false

var in_battle = false

var PlayerLastMoveEvaded = false
var PlayerLastMoveMissed = false

var EnemyLastMoveEvaded = false
var EnemyLastMoveMissed = false

enum  what_turn {ALLY_TURN, ENEMY_TURN}
var current_turn = what_turn.ALLY_TURN

func Ally_turn():
	print("Ally_turn")
	current_turn = what_turn.ALLY_TURN

func Enemy_turn():
	print("enemy_turn")
	current_turn = what_turn.ENEMY_TURN
	OpposingTrainerMonsters._attack()

func switch_turns():
	print("switch_turns")
	if current_turn == what_turn.ALLY_TURN:
		Enemy_turn()
	elif current_turn == what_turn.ENEMY_TURN:
		Ally_turn()

func _physics_process(_delta):
	
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