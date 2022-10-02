extends Control

onready var Player_sprite = $Player_pokemon_0/Poke_Sprite
onready var Enemy_sprite = $Enemy_pokemon_0/Poke_Sprite

onready var Player_health = $Player_pokemon_0/HealthBar
onready var Enemy_health = $Enemy_pokemon_0/HealthBar

onready var Player_exp = $Player_pokemon_0/Exp_bar

onready var tween = $Tween

var temp_enemy_health
var Enemy_health_set = false

var Player_health_set = false	
var temp_player_health
var initial_set = true
func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	if PlayerPokemon.current_pokemon != null:
		if Player_health_set == false:
			temp_player_health = PlayerPokemon.current_pokemon.Current_health_points
			Player_health_set = true
	if OpposingTrainerMonsters.pokemon != null:
		if Enemy_health_set == false:
			temp_enemy_health = OpposingTrainerMonsters.pokemon.Current_health_points
			Enemy_health_set = true

func _physics_process(_delta):
	if PlayerPokemon.current_pokemon != null:
		Player_health.max_value = (PlayerPokemon.current_pokemon.Max_health_points)
		Player_sprite.texture = (PlayerPokemon.current_pokemon.sprite)
		Player_exp.max_value = (PlayerPokemon.current_pokemon.experince_to_next_level)
		Player_exp.value = (PlayerPokemon.current_pokemon.experince_gained)
		if PlayerPokemon.current_pokemon.Current_health_points != temp_player_health:			
			tween.interpolate_property(Player_health, "value",
					temp_player_health, PlayerPokemon.current_pokemon.Current_health_points, 1,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			temp_player_health = PlayerPokemon.current_pokemon.Current_health_points
	else:
		Player_sprite.texture = null
	if OpposingTrainerMonsters.pokemon != null:
		Enemy_health.max_value = (OpposingTrainerMonsters.pokemon.Max_health_points)
		Enemy_sprite.texture = (OpposingTrainerMonsters.pokemon.sprite)
		if temp_enemy_health  != OpposingTrainerMonsters.pokemon.Current_health_points:
			tween.interpolate_property(Enemy_health, "value",
					temp_enemy_health, OpposingTrainerMonsters.pokemon.Current_health_points, 1,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			temp_enemy_health = OpposingTrainerMonsters.pokemon.Current_health_points
	else:
		Enemy_sprite.texture = null


func _change_turn(object:Object, _key:NodePath):
	if BattleManager.multi_battle == false:

		if object == Enemy_health:
			if PlayerPokemon.current_pokemon != null:
				if OpposingTrainerMonsters.pokemon != null and OpposingTrainerMonsters.pokemon.Current_health_points >= 1:
					BattleManager.Enemy_turn()
		elif object == Player_health:
			if PlayerPokemon.current_pokemon != null:
				if initial_set == true:
					get_parent().ui_state = get_parent().Ui_state.Main
					initial_set = false
				elif initial_set == false:
					get_parent().ui_state = get_parent().ui_state
				BattleManager.Ally_turn()

func _on_Tween_tween_completed(object:Object, key:NodePath):
	_change_turn(object, key)