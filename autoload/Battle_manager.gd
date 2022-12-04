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
var current_turn = what_turn.ENEMY_TURN

func Ally_turn():
	#print("Ally_turn")
	current_turn = what_turn.ALLY_TURN

func Enemy_turn():
	#print("Enemy_turn")
	current_turn = what_turn.ENEMY_TURN
	OpposingTrainerMonsters._attack()

func switch_turns():
	#print("Switch turns")
	if current_turn == what_turn.ALLY_TURN:
		Enemy_turn()
	elif current_turn == what_turn.ENEMY_TURN:
		Ally_turn()

func _physics_process(_delta):
	
	if OpposingTrainerMonsters.pokemon != null:
		PlayerPokemon.opposing_pokemon = OpposingTrainerMonsters.pokemon
	else:
		PlayerPokemon.opposing_pokemon = null
