extends KinematicBody2D

onready var Down_Detector = $Detectors/Down
onready var Up_Detector = $Detectors/Up
onready var Left_Detector = $Detectors/Left
onready var Right_Detector = $Detectors/Right

onready var sprite = $Sprite

var player

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

onready var dialog = Dialog.instance()

export(Array) var first_dialog

export(Array) var pokemons

export(Array) var pokemonLevels

export(String) var Name




func _ready():
	self.sprite.frame = 0
	self.sprite.scale = Vector2(1,1)

func _Start_dialog():
	if Left_Detector.is_colliding():
		sprite.frame = 2
		sprite.scale = Vector2(1,1)
	elif Right_Detector.is_colliding():
		sprite.frame = 2
		sprite.scale = Vector2(-1,1)
	elif Up_Detector.is_colliding():
		sprite.frame = 1
		sprite.scale = Vector2(1,1)
	elif Down_Detector.is_colliding():
		sprite.frame = 0
		sprite.scale = Vector2(1,1)

	dialog = Dialog.instance()
	dialog.text_to_diaplay = first_dialog
	Utils.get_dialog_layer().add_child(dialog)

		
	dialog.connect("Dialog_ended",self,"_finish_dialog")


func _finish_dialog():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		#player.interacting = false
		#player.is_talking = false
		player = null
		_prepare_for_fight()
	dialog = null


func _prepare_for_fight():
	BattleManager.type_of_battle = BattleManager.types_of_battle.Trainer

	_add_pokemon(0)

	OpposingTrainerMonsters.pokemons.append(pokemons[1])
	OpposingTrainerMonsters.pokemons.append(pokemons[2])
		
	after_done()

func after_done():
	Utils.get_player().set_physics_process(false)
	OpposingTrainerMonsters.pokemons = self.pokemons
	OpposingTrainerMonsters.active_trainers.append(self)
	if Utils.get_player().is_cycling == true:
		Utils.get_player().anim_state.travel("cycle_idle")
	elif Utils.get_player().is_surfing == true:
		Utils.get_player().anim_state.travel("surf")
	elif Utils.get_player().is_cycling == false:
		Utils.get_player().anim_state.travel("idle")
		Utils.get_player().stop_input = true
	Utils.Get_Scene_Manager().transition_to_pokemon_scene()

func _after_battle_done():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false
		player = null

func _add_pokemon(num):
	var Pokemon = pokemons[num].instance()
	LoadedPokemon.add_child(Pokemon)
	LoadedPokemon.current_loaded_pokemon = LoadedPokemon.get_child(0)

	Utils.parent_to_change = OpposingTrainerMonsters
	LoadedPokemon._change_parent()

	if num == 0:
		Pokemon.level = pokemonLevels[0]
	elif num == 1:
		Pokemon.level = pokemonLevels[1]

	Pokemon._calculate_stats()
	Pokemon._calculate_experience()
	Pokemon._calculate_gender()

	OpposingTrainerMonsters.pokemon = Pokemon

func get_pokemon_moves(PokemonName):
	for i in $Pokemons.get_children():
		if i.Name == PokemonName:
			return i.Moves