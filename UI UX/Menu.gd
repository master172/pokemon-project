extends CanvasLayer

const PokemonPartyScreen = preload("res://Scenes/PokemonPartyScene.tscn")
const Dialog = preload("res://UI UX/Dialogue_bar.tscn")
const BagScene = preload("res://Game resources/InventoryUi.tscn")

onready var select_arrow = $Control/NinePatchRect/TextureRect
onready var menu = $Control
onready var dialog = Dialog.instance()

enum ScreenLoaded {Nothing,Menu_only,Party_screen,Bag_screen}
var screen_loaded = ScreenLoaded.Nothing

var selected_option :int = 0
var party_screen
var bag_screen

var Name = "Menu"

var save_dialog = ["Do you want to save the game",1,0]
var save_question = [["Yes","ash saved the game",1],["No",1]]

func load_party_screen():
	menu.visible = false
	Utils.get_player().set_physics_process(false)
	screen_loaded = ScreenLoaded.Party_screen
	party_screen = PokemonPartyScreen.instance()
	add_child(party_screen)

func unload_party_screen():
	menu.visible = true
	screen_loaded = ScreenLoaded.Menu_only
	remove_child(party_screen)
	
func load_bag_scene():
	menu.visible = false
	Utils.get_player().set_physics_process(false)
	screen_loaded = ScreenLoaded.Bag_screen
	bag_screen = BagScene.instance()
	bag_screen.controller = self
	add_child(bag_screen)

func unload_bag_screen():
	menu.visible = true
	screen_loaded = ScreenLoaded.Menu_only
	remove_child(bag_screen)

func _ready():
	menu.visible = false
	select_arrow.rect_position.y = 6+ (selected_option % 7) * 15

func _save_game():
	
	if dialog != null:
		dialog = dialog
	else:
		dialog = Dialog.instance()
	
	dialog.text_to_diaplay = save_dialog
	dialog.choices = save_question
	Utils.get_dialog_layer().add_child(dialog)

	menu.visible = false		
	screen_loaded = ScreenLoaded.Nothing

		
	dialog.connect("Dialog_ended",self,"_finish_save_dialog")
	dialog.connect("_choice_number",self,"decide_save_choice",[dialog.selected_choice])
	

func decide_save_choice(choice,_choice_extra):
	if choice == 0:
		 Save_game_yes()
	elif choice == 1:
		Save_game_no()
	

func Save_game_no():
	print("not saving  the game")
	var player = get_parent().get_node("CurrentScene").get_children().back().find_node("ash")
	var currentScene = Utils.Get_Scene_Manager()

	
	player.set_physics_process(true)
	menu.visible = false		
	screen_loaded = ScreenLoaded.Nothing

func Save_game_yes():
	print("saving the game")
	var player = get_parent().get_node("CurrentScene").get_children().back().find_node("ash")
	var currentScene = Utils.Get_Scene_Manager().get_child(0)

	player._save_data()
	GameSaver.save_game()
	SceneLoaded._save_data()
	SaveAndLoad._save_menu()
	Utils._save_data()
	currentScene.save_game()
	
	player.set_physics_process(true)
	menu.visible = false		
	screen_loaded = ScreenLoaded.Nothing

func _finish_save_dialog():
	dialog = null

func _exit():
	var player = get_parent().get_node("CurrentScene").get_children().back().find_node("ash")
	player.set_physics_process(true)
	menu.visible = false		
	screen_loaded = ScreenLoaded.Nothing

func _input(event):
	match screen_loaded:
		ScreenLoaded.Nothing:
			if event.is_action_pressed("menu"):
				var player = get_parent().get_node("CurrentScene").get_children().back().find_node("ash")
				if !player.is_moving:
					player.set_physics_process(false)
					menu.visible = true
					screen_loaded = ScreenLoaded.Menu_only
		ScreenLoaded.Menu_only:
			if event.is_action_pressed("menu") or event.is_action_pressed("decline"):
				var player = get_parent().get_node("CurrentScene").get_children().back().find_node("ash")
				player.set_physics_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.Nothing
			elif event.is_action_pressed("S"):
				if selected_option == 6:
					selected_option = 0
				else:
					selected_option += 1
				select_arrow.rect_position.y = 6 + (selected_option % 7) * 15
			elif event.is_action_pressed("W"):
				if selected_option == 0:
					selected_option = 6
				else:
					selected_option -= 1
				select_arrow.rect_position.y = 6 + (selected_option % 7) * 15
			elif event.is_action_pressed("accept") and selected_option == 0:
				get_parent().transition_to_party_scene()
			elif event.is_action_pressed("accept") and selected_option== 2:
				get_parent().transition_to_bag_scene()
			elif event.is_action_pressed("accept") and selected_option == 4:
				_save_game()
			elif event.is_action_pressed("accept") and selected_option == 6:
				_exit()
			
		ScreenLoaded.Party_screen:
			if event.is_action_pressed("decline"):
				get_parent().transition_exit_party_scene()
		
