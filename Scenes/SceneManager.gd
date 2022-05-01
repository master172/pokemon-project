extends Node2D

var player_location = Vector2(0,0)
var player_direction = Vector2(0,0)

var next_scene

const pc = preload("res://UI UX/Pc.tscn")



enum Transition_Type  {NEW_SCENE, PARTY_SCENE, MENU_ONLY, POKEMON_SCENE,EXIT_POKEMON_SCENE,MOVE_LEARNER,EXIT_MOVE_LEARNER,PC,EXIT_PC}
var transition_type = Transition_Type.NEW_SCENE

func transition_to_Pc():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	var Pc = pc.instance()
	add_child(Pc)
	transition_type = Transition_Type.PC

func transition_exit_Pc():
	transition_type = Transition_Type.EXIT_PC

func transition_to_Move_learner():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	transition_type = Transition_Type.MOVE_LEARNER

func transition_exit_Move_learner():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	transition_type = Transition_Type.EXIT_MOVE_LEARNER

func transition_to_party_scene():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	transition_type = Transition_Type.PARTY_SCENE

func transition_exit_party_scene():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	transition_type = Transition_Type.MENU_ONLY

func transition_to_pokemon_scene():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	transition_type = Transition_Type.POKEMON_SCENE
	
func transition_exit_pokemon_scene():
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_in")
	transition_type = Transition_Type.EXIT_POKEMON_SCENE
	BattleManager.catched = false
	BattleManager.fainted = false
	BattleManager.turns = 0

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
			
			$CurrentScene.get_child(0).queue_free()
			$CurrentScene.add_child(load(next_scene).instance())
	
			var player = $CurrentScene.get_children().back().find_node("ash")
			player.set_spawn(player_location,player_direction)
			SceneLoaded.current_scene = String(next_scene)
		Transition_Type.PC:
			Utils.get_player().set_physics_process(false)
		Transition_Type.EXIT_PC:
			Utils.get_player().set_physics_process(true)
		Transition_Type.MOVE_LEARNER:
			$MoveLearner/Move_learner.current_pokemon = MoveLearner.target_pokemon
			$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Selection
			Utils.get_player().set_physics_process(false)
		Transition_Type.EXIT_MOVE_LEARNER:
			$MoveLearner/Move_learner.current_option = $MoveLearner/Move_learner.Options.Main
			Utils.get_player().set_physics_process(true)
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
	
	$ScreenTransition/ColorRect/AnimationPlayer.play("fade_out")


