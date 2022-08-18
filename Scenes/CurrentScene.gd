extends Node2D

var scene
var current_pokemon

func _ready():
	if SceneLoaded.current_scene != null:
		self.get_child(0).queue_free()
		_instance()

func _apply_data():
	if self.get_child(0).has_method("load_game"):
		self.get_child(0).load_game()

func _instance():
	scene= load(String(SceneLoaded.current_scene))
	var scene_instance = scene.instance()
	self.add_child(scene_instance)
	if scene_instance.has_method("load_game"):
		scene_instance.load_game()
	_check_pokemon()


func _check_pokemon():
	if OpposingTrainerMonsters.pokemon != null:
		if Utils.get_player().inside_grass == true:
			BattleManager.type_of_battle = BattleManager.types_of_battle.Wild
		current_pokemon = OpposingTrainerMonsters.pokemon
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