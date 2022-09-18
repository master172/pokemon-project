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
		player = null
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
		PlayerPokemon.first_pokemon.Current_health_points = PlayerPokemon.first_pokemon.Max_health_points
	if PlayerPokemon.second_pokemon != null:
		PlayerPokemon.second_pokemon.Current_health_points = PlayerPokemon.second_pokemon.Max_health_points
	if PlayerPokemon.third_pokemon != null:
		PlayerPokemon.third_pokemon.Current_health_points = PlayerPokemon.third_pokemon.Max_health_points
	if PlayerPokemon.fourth_pokemon != null:
		PlayerPokemon.fourth_pokemon.Current_health_points = PlayerPokemon.fourth_pokemon.Max_health_points
	if PlayerPokemon.fifth_pokemon != null:
		PlayerPokemon.fifth_pokemon.Current_health_points = PlayerPokemon.fifth_pokemon.Max_health_points
	if PlayerPokemon.sixth_pokemon != null:
		PlayerPokemon.sixth_pokemon.Current_health_points = PlayerPokemon.sixth_pokemon.Max_health_points
	return

func _healing_animation():
	if Cut_scene_player != null:
		var cut_scene_player = get_node(Cut_scene_player)
		cut_scene_player.play("Heal")
		cut_scene_player.connect("animation_finished",self,"_finish_healing_animation")
	
func _finish_healing_animation(anim_name:String):
	if anim_name == "Heal":
		healing = false
		_ending_dialog()

func _pre_requirements():
	dialog._finish_displaying()
	dialog.emit_signal("Dialog_ended")
	dialog.queue_free()