extends Node2D

export(int,"1","1/2","1/3","1/4") var encounter_rate

var rng = RandomNumberGenerator.new()
var rng_new = RandomNumberGenerator.new()
var rng_new_2 = RandomNumberGenerator.new()

export(bool) var is_invisible = false

onready var anim_player = $Sprite/AnimationPlayer

const grass_overlay_tecture = preload("res://assests/libraries/stepped_tall_grass.png")
const grass_stepped_effect = preload("res://libraries/grass_efeect.tscn")

var grass_overlay: Sprite = null

var player_inside :bool = false

export(int) var min_level
export(int) var max_level

export(Array,String,FILE) var pokemons

var current_pokemon

func _ready():
	if is_invisible:
		visible = false
	var player = Utils.get_player()
	player.connect("player_moving_signal",self,"player_exiting_grass")
	player.connect("player_stopped_signal",self,"player_in_grass")

func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()

func player_in_grass():
	if player_inside == true:
		var grassstepeffect = grass_stepped_effect.instance()
		grassstepeffect.position = Vector2(0,0)
		grassstepeffect.z_index = 1
		self.add_child(grassstepeffect)
		if is_invisible == false:
			grassstepeffect.visible = true
		else:
			grassstepeffect.visible = false
	
		
		grass_overlay = Sprite.new()
		grass_overlay.texture = grass_overlay_tecture
		grass_overlay.position = Vector2(0,0)
		grass_overlay.z_index = 1
		self.add_child(grass_overlay)
		if is_invisible == false:
			grass_overlay.visible = true
		else:
			grass_overlay.visible = false
		

func _on_Area2D_body_entered(_body):
	player_inside = true
	Utils.get_player().inside_grass = true
	anim_player.play("stepped")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "stepped":
		randomize_pokemon()

func _on_Area2D_body_exited(_body):
	Utils.get_player().inside_grass = false
	player_inside = false

func randomize_pokemon():
	rng.randomize()
	var in_battle : bool = false
	var rng_0 = rng.randi_range(0,3)
	if rng_0 == 0:
		in_battle = true
	else:
		in_battle = false
	if in_battle == true:
		if Utils.get_player().inside_grass == true:
			BattleManager.type_of_battle = BattleManager.types_of_battle.Wild
			encounter()


func encounter():
	if OpposingTrainerMonsters.pokemon == null:
		rng_new.randomize()
		var rng_1 = rng_new.randi_range(0,(pokemons.size()-1))
		current_pokemon = pokemons[rng_1].instance()
		LoadedPokemon.add_child(current_pokemon)
		LoadedPokemon.current_loaded_pokemon = LoadedPokemon.get_child(0)

		Utils.parent_to_change = OpposingTrainerMonsters
		LoadedPokemon._change_parent()
		set_properties()
	elif OpposingTrainerMonsters.pokemon != null:
		current_pokemon = OpposingTrainerMonsters.pokemon
		set_properties()


func set_properties():
	if current_pokemon != null:
		rng_new_2.randomize()
		var rng_2 = rng_new_2.randi_range(min_level,max_level)
		current_pokemon.level = rng_2
		current_pokemon._calculate_stats()
		current_pokemon._calculate_experience()
		after_done()

func after_done():
	Utils.get_player().set_physics_process(false)
	if Utils.get_player().is_cycling == true:
		Utils.get_player().anim_state.travel("cycle_idle")
	elif Utils.get_player().is_surfing == true:
		Utils.get_player().anim_state.travel("surf")
	elif Utils.get_player().is_cycling == false:
		Utils.get_player().anim_state.travel("idle")
		Utils.get_player().stop_input = true
	Utils.Get_Scene_Manager().transition_to_pokemon_scene()
