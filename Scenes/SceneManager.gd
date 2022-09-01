extends Node2D

var player_location = Vector2(0,0)
var player_direction = Vector2(0,0)

var next_scene

const pc = preload("res://UI UX/Pc.tscn")

var need_move_to_learn = false

var transition_queue : Array = []

enum Transition_Type  {NONE,NEW_SCENE, PARTY_SCENE, MENU_ONLY, POKEMON_SCENE,EXIT_POKEMON_SCENE,MOVE_LEARNER,EXIT_MOVE_LEARNER,PC,EXIT_PC,BAG_SCENE }
var transition_type = Transition_Type.NONE

enum Move_learn_transtion_type {MOVE_LEARNER,EXIT_MOVE_LEARNER}
var move_learn_transtion_type = Move_learn_transtion_type.MOVE_LEARNER

func _fade_in():
	if $ScreenTransition/ColorRect/AnimationPlayer.is_playing():
		$ScreenTransition/ColorRect/AnimationPlayer.stop()
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")

func _direct_change(scene):
	if scene == Transition_Type.POKEMON_SCENE:
		transition_type = Transition_Type.Pokemon_scene
		$ScreenTransition/ColorRect/AnimationPlayer.play("Init_fade_out")
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


func transition_to_Move_learner():
	_fade_in()
	Utils.get_player().set_physics_process(false)
	move_learn_transtion_type = Move_learn_transtion_type.MOVE_LEARNER
	need_move_to_learn = true


func transition_exit_Move_learner():
	_fade_in()
	yield(get_tree().create_timer(0.1),"timeout")
	Utils.get_player().set_physics_process(true)
	move_learn_transtion_type = Move_learn_transtion_type.EXIT_MOVE_LEARNER

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
	

	if need_move_to_learn == false:
		match transition_type:
			Transition_Type.NEW_SCENE:
				
				if $CurrentScene.get_child(0).has_method("save_game"):
					$CurrentScene.get_child(0).save_game()
				$CurrentScene.get_child(0).queue_free()
				$CurrentScene.add_child(load(next_scene).instance())
				
				var player = $CurrentScene.get_children().back().find_node("ash")
				player.set_spawn(player_location,player_direction)
				SceneLoaded.current_scene = String(next_scene)
				yield(get_tree().create_timer(0.1),"timeout")
				$CurrentScene._apply_data()
				

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
			Transition_Type.BAG_SCENE:
				$Menu.load_bag_scene()
		
		$ScreenTransition/ColorRect/AnimationPlayer.play("fade_out")
	else:
		
		match move_learn_transtion_type:
			Move_learn_transtion_type.EXIT_MOVE_LEARNER:
				$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Main
				$MoveLearner/Move_learner.selected_option = 0
				$MoveLearner/Move_learner.move_selected = 0
				need_move_to_learn = false
				match transition_type:
					Transition_Type.NEW_SCENE:
						
						$CurrentScene.get_child(0).queue_free()
						$CurrentScene.add_child(load(next_scene).instance())
				
						var player = $CurrentScene.get_children().back().find_node("ash")
						player.set_spawn(player_location,player_direction)
						SceneLoaded.current_scene = String(next_scene)
		
					Transition_Type.PARTY_SCENE:
						$Menu.load_party_screen()
					Transition_Type.POKEMON_SCENE:
						$Pokemon_scene.load_pokemon_scene()
						BattleManager.in_battle = true
					Transition_Type.MENU_ONLY:
						if$Menu.screen_loaded == $Menu.ScreenLoaded.Party_screen:
							$Menu.unload_party_screen()
					Transition_Type.EXIT_POKEMON_SCENE:
						$Pokemon_scene.unload_pokemon_scene()
						BattleManager.in_battle = false
			Move_learn_transtion_type.MOVE_LEARNER:
				Utils.get_player().set_physics_process(false)
				$MoveLearner/Move_learner.current_pokemon = MoveLearner.target_pokemon
				$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Selection
		$ScreenTransition/ColorRect/AnimationPlayer.play("fade_out")



