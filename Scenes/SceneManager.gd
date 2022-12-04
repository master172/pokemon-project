extends Node2D


var player_location = Vector2(0,0)
var player_direction = Vector2(0,0)

var next_scene

const pc = preload("res://UI UX/Pc.tscn")


var transition_queue : Array = []

onready var current_scene = $CurrentScene

enum Transition_Type  {NONE,NEW_SCENE, PARTY_SCENE, MENU_ONLY, POKEMON_SCENE,EXIT_POKEMON_SCENE,MOVE_LEARNER,EXIT_MOVE_LEARNER,PC,EXIT_PC,BAG_SCENE,EXIT_BATTLE_MOVE_LEARNER }
var transition_type = Transition_Type.NONE

func _ready():
	get_tree().set_current_scene(self)
	self.set_meta("Name","SceneManager")

func _fade_in():
	if $ScreenTransition/ColorRect/AnimationPlayer.is_playing():
		$ScreenTransition/ColorRect/AnimationPlayer.stop()
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")

func _direct_change(scene):
	if scene == Transition_Type.POKEMON_SCENE:
		transition_type = Transition_Type.POKEMON_SCENE
		$ScreenTransition/ColorRect/AnimationPlayer.play("Init_fade_out")
		BattleManager.type_of_battle = BattleManager.types_of_battle.Wild
		$Pokemon_scene.load_pokemon_scene()
		BattleManager.in_battle = true

func transition_to_Pc():
	SaveAndLoad.save_game()
	Utils.get_player().is_moving = false
	Utils.get_player().is_running = false
	Utils.get_player().is_cycling = false
	Utils.get_player().is_talking = false
	Utils.get_player().is_surfing = false
	Utils.get_player()._save_data()
	get_tree().change_scene_to(load("res://UI UX/Pc.tscn"))


func transition_to_Move_learner(move):
	
	if $Pokemon_scene.get_child_count() < 0:
		_fade_in()
		Utils.get_player().set_physics_process(false)
		transition_type = Transition_Type.MOVE_LEARNER
	elif $Pokemon_scene.get_child_count() > 0:
		$Pokemon_scene.get_child(0).ui_state = $Pokemon_scene.get_child(0).Ui_state.Dialogue
		$Pokemon_scene.get_child(0).start_move_learning(move)

func PokemonSceneMoveLearning():
	_fade_in()
	transition_type = Transition_Type.MOVE_LEARNER

func transition_exit_Move_learner():
	if $Pokemon_scene.get_child_count() < 0:
		_fade_in()
		yield(get_tree().create_timer(0.1),"timeout")
		Utils.get_player().set_physics_process(true)
		transition_type = Transition_Type.EXIT_MOVE_LEARNER
	elif $Pokemon_scene.get_child_count() > 0:
		checkExitBattleMoveLearning()

func checkExitBattleMoveLearning():
	if BattleManager.multi_battle == false:
		if OpposingTrainerMonsters.pokemon != null:
			if OpposingTrainerMonsters.pokemon.Current_health_points <= 0:
				_fade_in()
				yield(get_tree().create_timer(0.1),"timeout")
				Utils.get_player().set_physics_process(true)
				transition_type = Transition_Type.EXIT_BATTLE_MOVE_LEARNER
		elif OpposingTrainerMonsters.pokemon == null:
			_fade_in()
			yield(get_tree().create_timer(0.1),"timeout")
			Utils.get_player().set_physics_process(true)
			transition_type = Transition_Type.EXIT_BATTLE_MOVE_LEARNER
	
func transition_to_party_scene():
	_fade_in()
	transition_type = Transition_Type.PARTY_SCENE

func transition_exit_party_scene():
	_fade_in()
	transition_type = Transition_Type.MENU_ONLY

func transition_to_pokemon_scene():
	_fade_in()
	transition_type = Transition_Type.POKEMON_SCENE
	
	
func transition_exit_pokemon_scene():
	_fade_in()
	transition_type = Transition_Type.EXIT_POKEMON_SCENE
	BattleManager.catched = false
	BattleManager.fainted = false
	BattleManager.turns = 0

func transition_to_bag_scene():
	_fade_in()
	transition_type = Transition_Type.BAG_SCENE
	

func transition_exit_bag_scene():
	_fade_in()
	transition_type = Transition_Type.MENU_ONLY

func transition_to_scene(new_scene:String, spawn_location, spawn_direction):
	SaveAndLoad.save_game()
	Utils.get_player().is_moving = false
	Utils.get_player().is_running = false
	Utils.get_player().is_cycling = false
	Utils.get_player().is_talking = false
	Utils.get_player().is_surfing = false
	Utils.get_player()._save_data()
	next_scene = new_scene
	player_direction = spawn_direction
	player_location = spawn_location
	transition_type = Transition_Type.NEW_SCENE
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")


func finished_fading():
	match transition_type:
		Transition_Type.NEW_SCENE:
				
			current_scene.save_game()
			current_scene.get_child(0).queue_free()
			current_scene.add_child(load(next_scene).instance())
				
			var player = current_scene.get_children().back().find_node("ash")
			player.set_spawn(player_location,player_direction)
			SceneLoaded.current_scene = String(next_scene)
			yield(get_tree().create_timer(0.1),"timeout")
			current_scene._apply_data()

			
				

		Transition_Type.PARTY_SCENE:
			$Menu.load_party_screen()

		Transition_Type.POKEMON_SCENE:
			$Pokemon_scene.load_pokemon_scene()
			BattleManager.in_battle = true

		Transition_Type.MENU_ONLY:
			if$Menu.screen_loaded == $Menu.ScreenLoaded.Party_screen:
				$Menu.unload_party_screen()
			if$Menu.screen_loaded == $Menu.ScreenLoaded.Bag_screen:
				$Menu.unload_bag_screen()

		Transition_Type.EXIT_POKEMON_SCENE:
			$Pokemon_scene.unload_pokemon_scene()
			BattleManager.in_battle = false
			OpposingTrainerMonsters.pokemon = null
			OpposingTrainerMonsters._remove_children()
			PlayerPokemon.current_pokemon = null
			PlayerPokemon._start_evolution()
			Utils.get_player().interacting = false
			Utils.get_player().is_talking = false

		Transition_Type.BAG_SCENE:
			$Menu.load_bag_scene()
			
		Transition_Type.MOVE_LEARNER:
			Utils.get_player().set_physics_process(false)
			$MoveLearner/Move_learner.current_pokemon = MoveLearner.target_pokemon
			$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Selection
			
		Transition_Type.EXIT_MOVE_LEARNER:
			$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Main
			$MoveLearner/Move_learner.selected_option = 0
			$MoveLearner/Move_learner.move_selected = 0
			PlayerPokemon.current_learning_pokemon = null
			PlayerPokemon._start_evolution()
		
		Transition_Type.EXIT_BATTLE_MOVE_LEARNER:
			$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Main
			$MoveLearner/Move_learner.selected_option = 0
			$MoveLearner/Move_learner.move_selected = 0
			$Pokemon_scene.get_child(0).FinishMoveLearningProcess()
			PlayerPokemon.current_learning_pokemon = null
			PlayerPokemon._start_evolution()

		
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_out")

func _to_Pokemon_center():
	current_scene.save_game()
	current_scene.get_child(0).queue_free()
	current_scene.add_child(load(Utils.current_rest_shelter).instance())
				
	var player = current_scene.get_children().back().find_node("ash")
	player.set_spawn(Vector2(0,8),Vector2(0,-1))
	SceneLoaded.current_scene = String(Utils.current_rest_shelter)
	yield(get_tree().create_timer(0.1),"timeout")
	current_scene._apply_data()

	var nurse = current_scene.get_child(0).get_node("%Nurse-joy")
	var nurse_interaction = nurse.get_node("%InteractionArea")
	nurse_interaction.player = player
	nurse_interaction.player.interacting = true
	nurse_interaction.player.is_talking = true
	nurse_interaction.set_choice = "yes"
	nurse_interaction._pre_requirements()
	nurse_interaction._heal_pokemon()
	nurse_interaction._healing_animation()

func PokemonSceneMoveLearningDialog(move):
	if $Pokemon_scene.get_child_count() > 0:
		$Pokemon_scene.get_child(0).ui_state = $Pokemon_scene.get_child(0).Ui_state.Dialogue
		$Pokemon_scene.get_child(0).learning_a_move = true
		$Pokemon_scene.get_child(0).StartMoveLearnDialogue(move)

func _Call_save():
	var player = current_scene.get_children().back().find_node("ash")

	player._save_data()
	GameSaver.save_game()
	SceneLoaded._save_data()
	SaveAndLoad._save_menu()
	Utils._save_data()
	current_scene.save_game()
