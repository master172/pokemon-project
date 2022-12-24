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

var BatteledPokemon : Array = []
var BatteledExperiece : Array = []
var BatteledLevelUp : Array = []
var BatteledLevelPokemon : Array = []

signal TurnChangedEnemy
signal TurnChangedTrainer

var turn_counter = 0

var max_turns = 2

func Ally_turn():
	#print("Ally_turn")
	current_turn = what_turn.ALLY_TURN
	emit_signal("TurnChangedTrainer")

func Enemy_turn():
	#print("Enemy_turn")
	current_turn = what_turn.ENEMY_TURN
	OpposingTrainerMonsters._attack()
	emit_signal("TurnChangedEnemy")

func switch_turns():
	#print("Switch turns")

	if turns != max_turns:
		if current_turn == what_turn.ALLY_TURN:
			Enemy_turn()
		elif current_turn == what_turn.ENEMY_TURN:
			Ally_turn()
	else:
		turns = 0
		Ally_turn()

func _physics_process(_delta):
	if multi_battle == false:
		max_turns = 2
	if OpposingTrainerMonsters.pokemon != null:
		PlayerPokemon.opposing_pokemon = OpposingTrainerMonsters.pokemon
	else:
		PlayerPokemon.opposing_pokemon = null

func _clear_turns():
	turns = 0

func _incrementTurns():
	turns += 1