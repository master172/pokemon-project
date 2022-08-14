extends Control

onready var Do_You_want = $Do_you_want_to
onready var Do_you_yes = $Do_you_want_to/Option_container/VBoxContainer/Yes/Sprite
onready var Do_you_no = $Do_you_want_to/Option_container/VBoxContainer/No/Sprite

onready var Bag_layer = $Bag_layer
const pokemon_scene = preload("res://Scenes/Battle_pokemon.tscn")
const Bag = preload("res://Game resources/InventoryUi.tscn")

var Name = "Pokemon_scene_stage"
var player_pokemon
var enemy_pokemon

onready var opposing_pokemon_sprite = $Sprite
onready var player_pokemon_sprite = $Sprite2

onready var poke_selector = $Poke_box

onready var main_box = $Node2D
onready var battle_box = $Battle_box

var current_mouse_num = 0
var battle_mouse_num = 0
var max_num = 4

var max_pokemon_number = 6

var option_num = 0
enum Ui_state { Main,Battle,Pokemon,Selection,Bag,Option}

var ui_state = Ui_state.Main

onready var scroll_container = $Node2D

var charecter

var reset_pokemon = false

func _ready():
	ui_state = Ui_state.Selection

func _need_to_switch():
	pass
func _physics_process(_delta):
	if BattleManager.multi_battle == false:
		_single_battle()

func _single_battle():
	if PlayerPokemon.current_learning_pokemon == null:
	
		if OpposingTrainerMonsters.pokemon != null:
			if OpposingTrainerMonsters.pokemon.Current_health_points <= 0:
				OpposingTrainerMonsters.pokemon._lose()
				yield(get_tree().create_timer(0.2),"timeout")
				win()
		if PlayerPokemon.current_pokemon != null:
				if PlayerPokemon.current_pokemon.Current_health_points <= 0:
					PlayerPokemon.current_pokemon._lose()
					PlayerPokemon._active_pokemon()
					if PlayerPokemon.active_pokemon > 0:
						if reset_pokemon == false:		
							Do_You_want.visible = true
							ui_state = Ui_state.Option
					else:
						_run()
					
		
		if PlayerPokemon.current_pokemon != null:
			player_pokemon = PlayerPokemon.current_pokemon
			player_pokemon_sprite.texture = PlayerPokemon.current_pokemon.sprite
		elif PlayerPokemon.current_pokemon == null:
			player_pokemon = null
			player_pokemon_sprite.texture = null
		if OpposingTrainerMonsters.pokemon != null:
			enemy_pokemon = OpposingTrainerMonsters.pokemon
			opposing_pokemon_sprite.texture = enemy_pokemon.sprite
		else:
			enemy_pokemon = null
			opposing_pokemon_sprite.texture = null

		if BattleManager.current_turn == BattleManager.what_turn.ALLY_TURN:
			if ui_state == Ui_state.Main:
				main_box.visible = true
				battle_box.visible = false
			elif ui_state == Ui_state.Battle:
				main_box.visible = false
				battle_box.visible = true

			elif ui_state == Ui_state.Option:
				if option_num == 0:
					Do_you_yes.frame = 0
				else:
					Do_you_yes.frame = 1
				if option_num == 1:
					Do_you_no.frame = 0
				else:
					Do_you_no.frame = 1
			if ui_state != Ui_state.Option:
					Do_You_want.visible = false
			if Input.is_action_just_pressed("decline"):
				if ui_state == Ui_state.Battle:
					ui_state = Ui_state.Main
			if Input.is_action_just_pressed("accept"):
				if ui_state == Ui_state.Main:
					if current_mouse_num == 0:
						_attack_inp()
					elif current_mouse_num == 1:
						_bag()
					elif current_mouse_num == 2:
						_run()
					elif current_mouse_num == 3:
						_capture()
					elif current_mouse_num == 4:
						_change_pokemon()
				
				elif ui_state == Ui_state.Option:
					if option_num == 0:
						ui_state = Ui_state.Pokemon
						reset_pokemon = true
						_change_pokemon()
					elif option_num == 1:
						_run() 

				elif ui_state == Ui_state.Battle:
					if battle_mouse_num == 3:
						ui_state = Ui_state.Main
					elif battle_mouse_num == 4:
						if PlayerPokemon.current_pokemon.Learned_moves.size() >= 1:
							PlayerPokemon.current_pokemon.Learned_moves[0]._calculate_damage()
							BattleManager.turns += 1
							BattleManager.Enemy_turn()
					elif battle_mouse_num == 0:
						if PlayerPokemon.current_pokemon.Learned_moves.size() >= 2:
							PlayerPokemon.current_pokemon.Learned_moves[1]._calculate_damage()
							BattleManager.turns += 1
							BattleManager.Enemy_turn()
					elif battle_mouse_num == 1:
						if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3:
							PlayerPokemon.current_pokemon.Learned_moves[2]._calculate_damage()
							BattleManager.turns += 1
							BattleManager.Enemy_turn()
					elif battle_mouse_num == 2:
						if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4:
							PlayerPokemon.current_pokemon.Learned_moves[3]._calculate_damage()
							BattleManager.turns += 1
							BattleManager.Enemy_turn()
			
					
					
func _bag():
	var Bag_scene = Bag.instance()
	Bag_layer.add_child(Bag_scene)
	Bag_scene.controller = self
	ui_state = Ui_state.Bag

func _change_pokemon():
	var Pokemon_scene = pokemon_scene.instance()
	Pokemon_scene.controller = self
	ui_state = Ui_state.Pokemon
	print("memory")
	add_child(Pokemon_scene)

	
	

func _attack_inp():
	ui_state = Ui_state.Battle


func win():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		Utils.Num_loaded_pokemon -= 1
		OpposingTrainerMonsters.pokemon = null
		OpposingTrainerMonsters._remove_children()
		PlayerPokemon.current_pokemon = null
		BattleManager.fainted = true
		Utils.Get_Scene_Manager().transition_exit_pokemon_scene()
		

func _capture():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		Utils.parent_to_change = PlayerPokemon
		OpposingTrainerMonsters._change_parent()
		OpposingTrainerMonsters.pokemon = null
		OpposingTrainerMonsters._remove_children()
		PlayerPokemon.current_pokemon = null
		BattleManager.catched = true
		Utils.Get_Scene_Manager().transition_exit_pokemon_scene()
		

func _run():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		Utils.Num_loaded_pokemon -= 1
		Utils.Get_Scene_Manager().transition_exit_pokemon_scene()
		OpposingTrainerMonsters.pokemon = null
		OpposingTrainerMonsters._remove_children()
		PlayerPokemon.current_pokemon = null
		
	else:
		print("cant escape an trainer battle")

func _input(event):
	if BattleManager.multi_battle == false:
		if BattleManager.current_turn == BattleManager.what_turn.ALLY_TURN:
			if event is InputEventMouseButton:
				if event.is_pressed():
					if ui_state ==  Ui_state.Main:
						if event.button_index == BUTTON_WHEEL_UP:
							if current_mouse_num < max_num:
								current_mouse_num += 1
								for i in range(0,scroll_container.get_child_count()):
									scroll_container.get_child(i).position.x -= 101
							else:
								current_mouse_num = 0
						elif event.button_index == BUTTON_WHEEL_DOWN:
							if current_mouse_num != 0:
								current_mouse_num -= 1
								for i in range(0,scroll_container.get_child_count()):
									scroll_container.get_child(i).position.x += 101
							else:
								current_mouse_num = max_num
					elif ui_state == Ui_state.Battle:
						if event.button_index == BUTTON_WHEEL_UP:
							if battle_mouse_num < max_num:
								battle_mouse_num += 1
								for i in range(0,battle_box.get_child_count()):
									battle_box.get_child(i).position.x -= 101
							else:
								battle_mouse_num = 0
						elif event.button_index == BUTTON_WHEEL_DOWN:
							if battle_mouse_num != 0:
								battle_mouse_num -= 1
								for i in range(0,battle_box.get_child_count()):
									battle_box.get_child(i).position.x += 101
							else:
								battle_mouse_num = max_num

			if ui_state == Ui_state.Main:
				if event.is_action_pressed("A"):
					if ui_state == Ui_state.Main:
						if current_mouse_num != 0:
							current_mouse_num -= 1
							for i in range(0,scroll_container.get_child_count()):
								scroll_container.get_child(i).position.x += 101
						else:
							for i in range(0,scroll_container.get_child_count()):
								scroll_container.get_child(i).position.x += 101
							current_mouse_num = max_num
				elif event.is_action_pressed("D"):
					if ui_state == Ui_state.Main:
						if current_mouse_num < max_num:
							current_mouse_num += 1
							for i in range(0,scroll_container.get_child_count()):
								scroll_container.get_child(i).position.x -= 101
						else:
							for i in range(0,scroll_container.get_child_count()):
								scroll_container.get_child(i).position.x -= 101
							current_mouse_num = 0
			elif ui_state == Ui_state.Battle:
				if event.is_action_pressed("A"):
					if ui_state == Ui_state.Battle:
						if battle_mouse_num != 0:
							battle_mouse_num -= 1
							for i in range(0,battle_box.get_child_count()):
								battle_box.get_child(i).position.x += 101
						else:
							for i in range(0,battle_box.get_child_count()):
								battle_box.get_child(i).position.x += 101
							battle_mouse_num = max_num
				elif event.is_action_pressed("D"):
					if ui_state == Ui_state.Battle:
						if battle_mouse_num < max_num:
							battle_mouse_num += 1
							for i in range(0,battle_box.get_child_count()):
								battle_box.get_child(i).position.x -= 101
						else:
							battle_mouse_num = 0
							for i in range(0,battle_box.get_child_count()):
								battle_box.get_child(i).position.x -= 101
			elif ui_state == Ui_state.Option:
				print(option_num)
				if event.is_action_pressed("A"):
					if ui_state == Ui_state.Option:
						if option_num != 0:
							option_num -= 1
						else:
							option_num = 1
				elif event.is_action_pressed("D"):
					if ui_state == Ui_state.Option:
						if option_num < 1:
							option_num += 1
						else:
							option_num = 0
				elif event.is_action_pressed("S"):
					if ui_state == Ui_state.Option:
						if option_num != 0:
							option_num -= 1
						else:
							option_num = 1
				elif event.is_action_pressed("W"):
					if ui_state == Ui_state.Option:
						if option_num < 1:
							option_num += 1
						else:
							option_num = 0
				


