extends Control

onready var Player_sprite = $Player_pokemon_0/Poke_Sprite
onready var Enemy_sprite = $Enemy_pokemon_0/Poke_Sprite

onready var Player_health = $Player_pokemon_0/HealthBar
onready var Enemy_health = $Enemy_pokemon_0/HealthBar

onready var Player_exp = $Player_pokemon_0/Exp_bar

func _ready():
	pass

func _physics_process(_delta):
	if PlayerPokemon.current_pokemon != null:
		Player_health.max_value = (PlayerPokemon.current_pokemon.Max_health_points)
		Player_health.value = (PlayerPokemon.current_pokemon.Current_health_points)
		Player_sprite.texture = (PlayerPokemon.current_pokemon.sprite)
		Player_exp.max_value = (PlayerPokemon.current_pokemon.experince_to_next_level)
		Player_exp.value = (PlayerPokemon.current_pokemon.experince_gained)
	else:
		Player_sprite.texture = null
	if OpposingTrainerMonsters.pokemon != null:
		Enemy_health.max_value = (OpposingTrainerMonsters.pokemon.Max_health_points)
		Enemy_health.value = (OpposingTrainerMonsters.pokemon.Current_health_points)
		Enemy_sprite.texture = (OpposingTrainerMonsters.pokemon.sprite)
	else:
		Enemy_sprite.texture = null
