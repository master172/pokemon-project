extends CanvasLayer

const PokemonPartyScreen = preload("res://Scenes/PokemonPartyScene.tscn")

onready var select_arrow = $Control/NinePatchRect/TextureRect
onready var menu = $Control

enum ScreenLoaded {Nothing,Menu_only,Party_screen,}
var screen_loaded = ScreenLoaded.Nothing

var selected_option :int = 0
var party_screen

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
	


func _ready():
	menu.visible = false
	select_arrow.rect_position.y = 6+ (selected_option % 7) * 15

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
			elif event.is_action_pressed("accept") and selected_option == 6:
				var player = get_parent().get_node("CurrentScene").get_children().back().find_node("ash")
				player.set_physics_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.Nothing
			elif event.is_action_pressed("accept") and selected_option == 6:
				SaveAndLoad._save_menu()
				GameSaver.save_game()
		ScreenLoaded.Party_screen:
			if event.is_action_pressed("decline"):
				get_parent().transition_exit_party_scene()
