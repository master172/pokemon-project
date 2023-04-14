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

var current_cycle = 0
var nodes = []

var processing = false

var player_attack_queued = false
var queued_attacks = []

func _physics_process(_delta):
	if OpposingTrainerMonsters.pokemon != null:
		PlayerPokemon.opposing_pokemon = OpposingTrainerMonsters.pokemon
	else:
		PlayerPokemon.opposing_pokemon = null

func Generate_moves():
	if multi_battle == false:
		OpposingTrainerMonsters.CalcMovesSingle()

func _get_queue():
	if multi_battle == false:
		print(queued_attacks[0])
		return queued_attacks[0]