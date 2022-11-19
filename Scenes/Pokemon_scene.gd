extends CanvasLayer

const Pokemon_stage = preload("res://Scenes/Pokemon_scene_stage.tscn")

enum Screen_loaded {Nothing,Pokemon_stage}
var screen_loaded = Screen_loaded

var pokemon_scene

func _ready():
	pass


func load_pokemon_scene():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		if BattleManager.multi_battle == false:
			screen_loaded = Screen_loaded.Pokemon_stage
			pokemon_scene = Pokemon_stage.instance()
			add_child(pokemon_scene)
			BattleManager.in_battle = true
	elif BattleManager.type_of_battle == BattleManager.types_of_battle.Trainer:
		if BattleManager.multi_battle == false:
			screen_loaded = Screen_loaded.Pokemon_stage
			pokemon_scene = Pokemon_stage.instance()
			add_child(pokemon_scene)
			BattleManager.in_battle = true

func unload_pokemon_scene():
	screen_loaded = Screen_loaded.Nothing
	remove_child(pokemon_scene)
	Utils.get_player().set_physics_process(true)
	Utils.get_player().stop_input = false
	OpposingTrainerMonsters.pokemon = null
	BattleManager.in_battle = false
	
	
	
	

func _unhandled_input(_event):
	match screen_loaded:
		Screen_loaded.Nothing:
			pass
