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
	scene = load(String(SceneLoaded.current_scene))
	var scene_instance = scene.instance()
	self.add_child(scene_instance)
	if scene_instance.has_method("load_game"):
		scene_instance.load_game()
	_check_pokemon()


func _check_pokemon():
	print("checking")
	if OpposingTrainerMonsters.get_child_count() != 0:
		print("has_pokemon")
		if Utils.get_player().inside_grass == true:
			BattleManager.type_of_battle = BattleManager.types_of_battle.Wild
		OpposingTrainerMonsters.pokemon = OpposingTrainerMonsters.get_child(0)
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
	Utils.Get_Scene_Manager()._direct_change(Utils.Get_Scene_Manager().Transition_Type.POKEMON_SCENE)
		

func save_game():
	if self.get_child_count() > 0:
		if self.get_child(0).has_method("save_game"):
			self.get_child(0).save_game()