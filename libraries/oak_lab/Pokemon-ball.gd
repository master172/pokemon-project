extends StaticBody2D

export(PackedScene) var Pokemon

onready var pokemon = Pokemon.instance()

var player

var talked = false
const Dialog = preload("res://UI UX/Dialogue_bar.tscn")


onready var first_dialog :Array = ["Ash went to the "  + pokemon.Name ,3," do you want to choose the "+pokemon.Name + "  as your first pokemon",1,2,0]


onready var question :Array = [["yes","Ash choosed the "+ pokemon.Name," congratulations on choosing your first pokemon " + " Take good care of it",1],["no","choose wisely ash this decesion is very important",1]]

onready var first_functions :Array = ["add_pokemon"]


var dialog = Dialog.instance()

var set_choice

var used = false

func _ready():
	pokemon.level = 5
	pokemon._calculate_stats()
	pokemon._calculate_experience()
	pokemon._calculate_gender()
	

func _selected(_no_idea):
	if set_choice == "yes":
		self.add_child(pokemon)
		Utils.parent_to_change = PlayerPokemon
		pokemon.change_parent()
		self.visible = false
		$CollisionShape2D.disabled = true
		used = true



func _apply_data():
	if self.used == true:
		self.visible = false
		$CollisionShape2D.disabled = true




func _Start_dialog():

	if PlayerPokemon.first_pokemon == null:

		if dialog != null:
			dialog = dialog
		else:
			dialog = Dialog.instance()
		
		dialog.text_to_diaplay = first_dialog
		dialog.choices = question
		dialog.functions = first_functions
		dialog.display_pokemon = pokemon.sprite
		Utils.get_dialog_layer().add_child(dialog)

			
		dialog.connect("Dialog_ended",self,"_finish_dialog")
		dialog.connect("_function",self,"_selected")
		dialog.connect("_choice_number",self,"_set_choice")
	else:

		if dialog != null:
			dialog = dialog
		else:
			dialog = Dialog.instance()
		
		dialog.text_to_diaplay = ["you may only choose one pokemon",0]
		Utils.get_dialog_layer().add_child(dialog)
	
		dialog.connect("Dialog_ended",self,"_finish_dialog")

func save():
	var save_dict = {
		"used":used,
		"pos_x" : position.x,
		"pos_y" : position.y,
	}
	return save_dict

func _finish_dialog():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false
		player = null
	dialog = null

func _set_choice(choice):
	if choice == 0:
		set_choice = "yes"
	elif choice == 1:
		set_choice = "no"

