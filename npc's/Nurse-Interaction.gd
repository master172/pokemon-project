extends Area2D

var player

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")
onready var dialog = Dialog.instance()

var dialog_functions = []

var greeting_dialog = true
var greetings_dialog = ["Greetings, would you like to rest your pokemon",1,2,0]
var greetings_question = [["yes","very well please give us your pokemon for a few seconds",1],["no","very well, Please take care",1]]

var endings_dialog = ["We have healed your pokemon, Please take care",0]

var set_choice = ""

export var Cut_scene_player :NodePath

var healing = false

func _ready():
	pass

func _Start_dialog():
	if healing == false and greeting_dialog == true:
		dialog = Dialog.instance()
		dialog.text_to_diaplay = greetings_dialog
		dialog.choices = greetings_question
		Utils.get_dialog_layer().add_child(dialog)
			
		dialog.connect("Dialog_ended",self,"_finish_dialog")
		dialog.connect("_choice_number",self,"_set_choice")
		dialog.connect("_function",self,"_function_manager")
			

func _set_choice(choice):
	if choice == 0:
		set_choice = "yes"
	elif choice == 1:
		set_choice = "no"
	dialog_functions = ["Choice",[self.set_choice]]
	dialog.functions = dialog_functions

func _finish_dialog():
	if player != null:
		greeting_dialog = true
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false	
	dialog = null
		

func _function_manager(function):
	if function[0] == "Choice":
		choice_results(function[1][0])

func choice_results(choice):
	if choice == "yes":
		if player != null:
			player.interacting = true
			player.is_talking = true
		_pre_requirements()
		_heal_pokemon()
		_healing_animation()
		
	else:
		_ending_dialog()

func _ending_dialog():
	if set_choice == "yes" and healing == false:
		greeting_dialog = not greeting_dialog
		if greeting_dialog == false:
			if Cut_scene_player != null:
				var cut_scene_player = get_node(Cut_scene_player)
				cut_scene_player.disconnect("animation_finished",self,"_finish_healing_animation")
		dialog = Dialog.instance()
		dialog.text_to_diaplay = endings_dialog
		Utils.get_dialog_layer().add_child(dialog)
		
		dialog.connect("Dialog_ended",self,"_finish_dialog")

func _heal_pokemon():
	healing = true
	if PlayerPokemon.first_pokemon != null:
		PlayerPokemon.first_pokemon._heal()
	if PlayerPokemon.second_pokemon != null:
		PlayerPokemon.second_pokemon._heal()
	if PlayerPokemon.third_pokemon != null:
		PlayerPokemon.third_pokemon._heal()
	if PlayerPokemon.fourth_pokemon != null:
		PlayerPokemon.fourth_pokemon._heal()
	if PlayerPokemon.fifth_pokemon != null:
		PlayerPokemon.fifth_pokemon._heal()
	if PlayerPokemon.sixth_pokemon != null:
		PlayerPokemon.sixth_pokemon._heal()
	return

func _healing_animation():
	if Cut_scene_player != null:
		var cut_scene_player = get_node(Cut_scene_player)
		cut_scene_player.play("Heal")
		cut_scene_player.connect("animation_finished",self,"_finish_healing_animation")
	
func _finish_healing_animation(anim_name:String):
	if anim_name == "Heal":
		healing = false
		var _player = Utils.get_player()
		var currentScene = Utils.Get_Scene_Manager().get_child(0)

		_player._save_data()
		GameSaver.save_game()
		SceneLoaded._save_data()
		SaveAndLoad._save_menu()
		Utils._save_data()
		currentScene.save_game()
		
		_ending_dialog()

func _pre_requirements():
	dialog._finish_displaying()
	dialog.emit_signal("Dialog_ended")
	dialog.queue_free()
	Utils.current_rest_shelter = String(self.get_parent().get_parent().filename)

