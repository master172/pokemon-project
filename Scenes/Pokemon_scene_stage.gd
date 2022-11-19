extends Control

onready var Do_You_want = $Do_you_want_to
onready var Do_you_yes = $Do_you_want_to/Option_container/VBoxContainer/Yes/Sprite
onready var Do_you_no = $Do_you_want_to/Option_container/VBoxContainer/No/Sprite
onready var Dialogue_layer = $Dialog_layer
onready var Bag_layer = $Bag_layer
onready var EventManger = $EventManager
onready var PokemonTrainerManager = $Opoosing_Trainers_Container

const pokemon_scene = preload("res://Scenes/Battle_pokemon.tscn")
const Bag = preload("res://Game resources/InventoryUi.tscn")
const Dialog = preload("res://UI UX/Dialogue_bar.tscn")


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
enum Ui_state { Main,Battle,Pokemon,Selection,Bag,Option,Dialogue,MoveLearner}

var ui_state = Ui_state.Main

onready var scroll_container = $Node2D

var charecter

var reset_pokemon = false

var enemy_dialogue_connected = false

var enemy_lost_dialogue_connected = false

var current_attack_locked = false

var lose_oneshot = false

var learning_a_move = false

var win_exp_points

func _ready():
	ui_state = Ui_state.Dialogue
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		if BattleManager.multi_battle == false:
			_initial_dialogue()
	else:
		if BattleManager.multi_battle == false:
			_trainer_battle()

func _display_enemy_attack_dialogue(pokemon,move):
	
	ui_state = Ui_state.Dialogue
	if ui_state == Ui_state.Dialogue:

		if BattleManager.multi_battle == false:
			if OpposingTrainerMonsters.pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					#start error fixing from here
					if self.get_child(0).current_event != null:
						
						yield(self.get_child(0),'finished_event')
						
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = ["The opposing "+ pokemon.Name + " used "+ pokemon.Learned_moves[move].Name, 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_finish_Enemy_attack_dialogue")

					elif self.get_child(0).current_event == null:
						yield(self.get_node("%Dialog_layer"),"child_exiting_tree")
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = ["The opposing "+ pokemon.Name + " used "+ pokemon.Learned_moves[move].Name, 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_finish_Enemy_attack_dialogue")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = ["The opposing "+ pokemon.Name + " used "+ pokemon.Learned_moves[move].Name, 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_finish_Enemy_attack_dialogue")

func _finish_Enemy_attack_dialogue():
	if BattleManager.multi_battle == false:
		ui_state = Ui_state.Battle
		OpposingTrainerMonsters.pokemon._wild_battle_attack()
		if BattleManager.EnemyLastMoveEvaded == true:
			ui_state = Ui_state.Dialogue
			_enemy_attack_evaded()
		elif BattleManager.EnemyLastMoveMissed == true:
			ui_state = Ui_state.Dialogue
			_enemy_attack_missed()
		elif BattleManager.EnemyLastMoveEvaded == false and BattleManager.EnemyLastMoveMissed == false:
			BattleManager.Ally_turn()
			current_attack_locked = false

func _enemy_attack_missed():
	if ui_state == Ui_state.Dialogue:
		if Dialogue_layer.get_child_count() > 0:
			if self.get_child(0).current_event != null:
				yield(self.get_child(0),'finished_event')
		
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = ["But it missed", 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_enemy_finish_attack_missed")
		else:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["But it missed", 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_enemy_finish_attack_missed")
	

func _enemy_finish_attack_missed():
	
	ui_state = Ui_state.Battle
	BattleManager.Ally_turn()
	current_attack_locked = false
	BattleManager.EnemyLastMoveMissed = false

func _enemy_attack_evaded():
	if ui_state == Ui_state.Dialogue:
		if Dialogue_layer.get_child_count() > 0:
			if self.get_child(0).current_event != null:
				yield(self.get_child(0),'finished_event')		
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = ["But it was evaded", 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_enemy_finish_attack_evaded")
		else:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["But it was evaded", 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_enemy_finish_attack_evaded")


func _enemy_finish_attack_evaded():
	ui_state = Ui_state.Battle
	BattleManager.Ally_turn()
	current_attack_locked = false
	BattleManager.EnemyLastMoveEvaded = false

func _attack_missed():
	if ui_state == Ui_state.Dialogue:
		if Dialogue_layer.get_child_count() > 0:
			if self.get_child(0).current_event != null:
				yield(self.get_child(0),'finished_event')	
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = ["But it missed", 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_finish_attack_missed")
		else:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["But it missed", 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_finish_attack_missed")


func _finish_attack_missed():
	ui_state = Ui_state.Battle
	BattleManager.Enemy_turn()
	BattleManager.PlayerLastMoveMissed = false

func _attack_evaded():
	if ui_state == Ui_state.Dialogue:
		if Dialogue_layer.get_child_count() > 0:
			if self.get_child(0).current_event != null:
				yield(self.get_child(0),'finished_event')
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = ["But it was evaded", 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_finish_attack_evaded")
		else:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["But it was evaded", 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_finish_attack_evaded")


func _finish_attack_evaded():
	ui_state = Ui_state.Battle
	BattleManager.Enemy_turn()
	BattleManager.PlayerLastMoveEvaded = false


func _Dialog_end(STATE):
	if $Dialog_layer.get_child_count() != 0:
		Dialogue_layer.get_child(0).queue_free()
		ui_state = STATE

func _physics_process(_delta):
	if EventManger.current_event == null:
			if BattleManager.multi_battle == false:
				if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
					_single_battle()
				else:
					_trainer_battle_process()

func _initial_dialogue():
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if OpposingTrainerMonsters.pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')			
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = ["A wild " + OpposingTrainerMonsters.pokemon.Name + " appeared","What pokemon will ash send", 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_finish_Init_dialogue")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = ["A wild " + OpposingTrainerMonsters.pokemon.Name + " appeared","What pokemon will ash send", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_finish_Init_dialogue")				

func _finish_Init_dialogue():
	ui_state = Ui_state.Selection
	$Poke_box.can_select = true

func _player_attack_dialogue(move):
	ui_state = Ui_state.Dialogue
	if Dialogue_layer.get_child_count() > 0:
		if self.get_child(0).current_event != null:
			yield(self.get_child(0),'finished_event')	
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name + " used "+PlayerPokemon.current_pokemon.Learned_moves[move].Name, 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_finish_player_attack_dialogue",[move])
	else:
		var Dialogue = Dialog.instance()
		Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name + " used "+PlayerPokemon.current_pokemon.Learned_moves[move].Name, 0]
		Dialogue_layer.add_child(Dialogue)
		Dialogue.connect("Dialog_ended",self,"_finish_player_attack_dialogue",[move])

func _finish_player_attack_dialogue(move):
	
	ui_state = Ui_state.Battle
	PlayerPokemon.current_pokemon.Learned_moves[move]._calculate_damage()
	if BattleManager.PlayerLastMoveEvaded == true:
		ui_state = Ui_state.Dialogue
		_attack_evaded()
	elif BattleManager.PlayerLastMoveMissed == true:
		ui_state = Ui_state.Dialogue
		_attack_missed()
	BattleManager.turns += 1
	
func _Run_dialogue():
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if PlayerPokemon.current_pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')	
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = ["Got away safely", 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_run")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = ["Got away safely", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_run")

func _Init_lose_dialogue():
	
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if OpposingTrainerMonsters.pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = [ PlayerPokemon.current_pokemon.Name + " fainted", 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_lose_process")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [ PlayerPokemon.current_pokemon.Name + " fainted", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_lose_process")


func _lose_process():
	yield(get_tree().create_timer(0.2),"timeout")
	if PlayerPokemon.active_pokemon > 0:
		if reset_pokemon == false:
			Do_You_want.visible = true	
			ui_state = Ui_state.Option
			
	else:
		ui_state = Ui_state.Dialogue
		total_loss()

func total_loss():
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if OpposingTrainerMonsters.pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = ["Ash was defeated by the opponent","Ash whited out", 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_total_loss_process")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = ["Ash was defeated by the opponent","Ash whited out", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_total_loss_process")

func _total_loss_process():
	yield(get_tree().create_timer(0.2),"timeout")
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		Utils.Num_loaded_pokemon -= 1
		Utils.Get_Scene_Manager().transition_exit_pokemon_scene()
		OpposingTrainerMonsters.pokemon = null
		OpposingTrainerMonsters._remove_children()
		PlayerPokemon.current_pokemon = null
		var SceneManager = Utils.Get_Scene_Manager()
		SceneManager._to_Pokemon_center()

func Pokemon_Comeback_Init():
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if PlayerPokemon.current_pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = ["Ash called " +PlayerPokemon.current_pokemon.Name +" back", 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"PokemonComebackProcess")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = ["Ash called " +PlayerPokemon.current_pokemon.Name +" back", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"PokemonComebackProcess")

func PokemonComebackProcess():
	yield(get_tree().create_timer(0.2),"timeout")
	_change_pokemon()

func IchoosePokemon(pokemon):
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if Dialogue_layer.get_child_count() > 0:
				if self.get_child(0).current_event != null:
					yield(self.get_child(0),'finished_event')
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [pokemon.Name +" I choose you", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"PokemonChoosingProcess")
			else:
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = [pokemon.Name +" I choose you", 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"PokemonChoosingProcess")

func PokemonChoosingProcess():
	yield(get_tree().create_timer(0.2),"timeout")
	ui_state = Ui_state.Main

func _single_battle():
	PokemonTrainerManager.visible = false
	if PlayerPokemon.current_learning_pokemon == null:

		if ui_state == Ui_state.Selection:
			$Poke_box.visible = true
		else:
			$Poke_box.visible = false
	


		if PlayerPokemon.current_pokemon != null:
				if PlayerPokemon.current_pokemon.Current_health_points <= 0:
					if lose_oneshot == false:
						PlayerPokemon.current_pokemon._lose()
						ui_state = Ui_state.Dialogue
						_Init_lose_dialogue()
						lose_oneshot = true
						
						
					
		
		if PlayerPokemon.current_pokemon != null:
			player_pokemon = PlayerPokemon.current_pokemon
			player_pokemon_sprite.texture = PlayerPokemon.current_pokemon.sprite
		elif PlayerPokemon.current_pokemon == null:
			player_pokemon = null
			player_pokemon_sprite.texture = null
		if OpposingTrainerMonsters.pokemon != null:
			enemy_pokemon = OpposingTrainerMonsters.pokemon
			if enemy_dialogue_connected == false:

				OpposingTrainerMonsters.pokemon.connect("Enemy_attacked",self,"_display_enemy_attack_dialogue")
				enemy_dialogue_connected = true
			if enemy_lost_dialogue_connected == false:
				OpposingTrainerMonsters.pokemon.connect("enemy_lost",self,"_win_dialog")
				enemy_lost_dialogue_connected = true
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
			if BattleManager.current_turn == BattleManager.what_turn.ALLY_TURN :
				if Input.is_action_just_pressed("accept") and Dialogue_layer.get_child_count() == 0:
					if ui_state != Ui_state.Dialogue:
						if ui_state == Ui_state.Main:
							if current_mouse_num == 0:
								_attack_inp()
							elif current_mouse_num == 1:
								_bag()
							elif current_mouse_num == 2:
								ui_state = Ui_state.Dialogue
								_Run_dialogue()
							elif current_mouse_num == 3:
								_capture()
							elif current_mouse_num == 4:
								ui_state = Ui_state.Dialogue
								Pokemon_Comeback_Init()
								
						
						elif ui_state == Ui_state.Option:
							if option_num == 0:
								ui_state = Ui_state.Pokemon
								reset_pokemon = true
								ui_state = Ui_state.Dialogue
								Pokemon_Comeback_Init()
							elif option_num == 1:
								ui_state = Ui_state.Dialogue
								_Run_dialogue()

						elif ui_state == Ui_state.Battle:
							if battle_mouse_num == 3:
								ui_state = Ui_state.Main
							elif battle_mouse_num == 4:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 1 and current_attack_locked == false:
									current_attack_locked = true
									_player_attack_dialogue(0)
							elif battle_mouse_num == 0:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 2 and current_attack_locked == false:
									current_attack_locked = true
									_player_attack_dialogue(1)
							elif battle_mouse_num == 1:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3 and current_attack_locked == false: 
									current_attack_locked = true
									_player_attack_dialogue(2)
							elif battle_mouse_num == 2:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4 and current_attack_locked == false:
									current_attack_locked = true
									_player_attack_dialogue(3)
			
					
func _bag():
	var Bag_scene = Bag.instance()
	Bag_layer.add_child(Bag_scene)
	Bag_scene.controller = self
	ui_state = Ui_state.Bag

func _change_pokemon():
	var Pokemon_scene = pokemon_scene.instance()
	Pokemon_scene.controller = self
	ui_state = Ui_state.Pokemon
	add_child(Pokemon_scene)

func _win_dialog(exp_points = 0):
	if exp_points != 0:
		win_exp_points = exp_points

	yield(get_tree().create_timer(0.2),"timeout")
	if learning_a_move == false and Dialogue_layer.get_child_count() == 0:
		if exp_points != 0:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name,String(PlayerPokemon.current_pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"win")
		elif exp_points == 0:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name,String(PlayerPokemon.current_pokemon.Name + " gained "+ String(int(win_exp_points))+ " experience points"), 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"win")
			win_exp_points = 0
	if learning_a_move == false and Dialogue_layer.get_child_count() > 0:
		if self.get_child(0).current_event != null:
			yield(self.get_child(0),'finished_event')
			if exp_points != 0:
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name,String(PlayerPokemon.current_pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"win")
			elif exp_points == 0:
				var Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name,String(PlayerPokemon.current_pokemon.Name + " gained "+ String(int(win_exp_points))+ " experience points"), 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"win")
				win_exp_points = 0

func _single_battle_win_dialog(exp_points = 0):
	if exp_points != 0:
		win_exp_points = exp_points
	
	yield(get_tree().create_timer(0.2),"timeout")

	if learning_a_move == false and Dialogue_layer.get_child_count() == 0:
		if exp_points != 0:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name,String(PlayerPokemon.current_pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_check_win")

func _check_win():
	if OpposingTrainerMonsters.pokemons.size() >= 0 or OpposingTrainerMonsters.pokemon != null:
		_change_opposing_pokemon()
		pass
	else:
		win()

func _change_opposing_pokemon():
	OpposingTrainerMonsters.pokemon = null

func _attack_inp():
	ui_state = Ui_state.Battle


func win():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		Utils.Num_loaded_pokemon -= 1
		OpposingTrainerMonsters.pokemon.disconnect("enemy_lost",self,"_win_dialog")
		OpposingTrainerMonsters.pokemon.disconnect("Enemy_attacked",self,"_display_enemy_attack_dialogue")
		enemy_dialogue_connected = false
		
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
	if BattleManager.current_turn == BattleManager.what_turn.ALLY_TURN :
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

func start_move_learning(move):
	
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if PlayerPokemon.current_pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')
						learning_a_move = true
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name +" wants to learn " + move.Name," how ever "+ PlayerPokemon.current_pokemon.Name + " already knows four moves please choose what to do", 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"MoveLearningProcess")
				else:
					learning_a_move = true
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name +" wants to learn " + move.Name," how ever "+ PlayerPokemon.current_pokemon.Name + " already knows four moves please choose what to do", 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"MoveLearningProcess")


func MoveLearningProcess():
	ui_state = Ui_state.MoveLearner
	var scenceManager = Utils.Get_Scene_Manager()
	scenceManager.PokemonSceneMoveLearning()

func FinishMoveLearningProcess():
	learning_a_move = false
	if BattleManager.multi_battle == false:
		if PlayerPokemon.current_pokemon != null:
			_win_dialog(0)

func StartMoveLearnDialogue(move):
	if ui_state == Ui_state.Dialogue:
		if BattleManager.multi_battle == false:
			if PlayerPokemon.current_pokemon != null:
				if Dialogue_layer.get_child_count() > 0:
					if self.get_child(0).current_event != null:
						yield(self.get_child(0),'finished_event')
						learning_a_move = true
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name +" learned " + move.Name, 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"StartMoveLearnProcess")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name +" learned " + move.Name, 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"StartMoveLearnProcess")
	
func StartMoveLearnProcess():
	learning_a_move = false
	if BattleManager.multi_battle == false:
		if PlayerPokemon.current_pokemon != null:
			_win_dialog(0)

func _trainer_battle():
	opposing_pokemon_sprite.visible = false
	PokemonTrainerManager.visible = true
	get_node("%TrainerPlayer").play("ComeIn")
	yield(get_node("%TrainerPlayer"),"animation_finished")
	ui_state = Ui_state.Dialogue
	_single_trainer_battle_dialogue()


func _single_trainer_battle_dialogue():
	if ui_state == Ui_state.Dialogue:
		var Dialogue = Dialog.instance()
		Dialogue.text_to_diaplay = [OpposingTrainerMonsters.active_trainers[0].Name + " wants to battle",OpposingTrainerMonsters.active_trainers[0].Name + " sent his pokemon for battle",0]

		Dialogue_layer.add_child(Dialogue)
		Dialogue.connect("Dialog_ended",self,"_trainer_battle_init")

func _trainer_battle_init():
	get_node("%TrainerPlayer").play("ComeOut")
	yield(get_node("%TrainerPlayer"),"animation_finished")
	opposing_pokemon_sprite.visible = true
	PokemonTrainerManager.visible = false
	_single_trainer_battle_choose_your_pokemon()

func _single_trainer_battle_choose_your_pokemon():
	if ui_state == Ui_state.Dialogue:
		var Dialogue = Dialog.instance()
		Dialogue.text_to_diaplay = ["What pokemon will ash send",0]

		Dialogue_layer.add_child(Dialogue)
		Dialogue.connect("Dialog_ended",self,"_choosing_single_trainer_battle_pokemon")

func _choosing_single_trainer_battle_pokemon():
		ui_state = Ui_state.Selection
		$Poke_box.can_select = true

func _trainer_battle_process():
	PokemonTrainerManager.visible = true
	
	if PlayerPokemon.current_learning_pokemon == null:

		if ui_state == Ui_state.Selection:
			$Poke_box.visible = true
		else:
			$Poke_box.visible = false
	


		if PlayerPokemon.current_pokemon != null:
				if PlayerPokemon.current_pokemon.Current_health_points <= 0:
					if lose_oneshot == false:
						PlayerPokemon.current_pokemon._lose()
						ui_state = Ui_state.Dialogue
						_Init_lose_dialogue()
						lose_oneshot = true
						
						
					
		
		if PlayerPokemon.current_pokemon != null:
			player_pokemon = PlayerPokemon.current_pokemon
			player_pokemon_sprite.texture = PlayerPokemon.current_pokemon.sprite
		elif PlayerPokemon.current_pokemon == null:
			player_pokemon = null
			player_pokemon_sprite.texture = null
		if OpposingTrainerMonsters.pokemon != null:
			enemy_pokemon = OpposingTrainerMonsters.pokemon
			if enemy_dialogue_connected == false:

				OpposingTrainerMonsters.pokemon.connect("Enemy_attacked",self,"_display_enemy_attack_dialogue")
				enemy_dialogue_connected = true
			if enemy_lost_dialogue_connected == false:
				OpposingTrainerMonsters.pokemon.connect("enemy_lost",self,"_win_dialog")
				enemy_lost_dialogue_connected = true
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
			if BattleManager.current_turn == BattleManager.what_turn.ALLY_TURN :
				if Input.is_action_just_pressed("accept") and Dialogue_layer.get_child_count() == 0:
					if ui_state != Ui_state.Dialogue:
						if ui_state == Ui_state.Main:
							if current_mouse_num == 0:
								_attack_inp()
							elif current_mouse_num == 1:
								_bag()
							elif current_mouse_num == 2:
								ui_state = Ui_state.Dialogue
								_Run_dialogue()
							elif current_mouse_num == 3:
								_capture()
							elif current_mouse_num == 4:
								ui_state = Ui_state.Dialogue
								Pokemon_Comeback_Init()
								
						
						elif ui_state == Ui_state.Option:
							if option_num == 0:
								ui_state = Ui_state.Pokemon
								reset_pokemon = true
								ui_state = Ui_state.Dialogue
								Pokemon_Comeback_Init()
							elif option_num == 1:
								ui_state = Ui_state.Dialogue
								_Run_dialogue()

						elif ui_state == Ui_state.Battle:
							if battle_mouse_num == 3:
								ui_state = Ui_state.Main
							elif battle_mouse_num == 4:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 1 and current_attack_locked == false:
									current_attack_locked = true
									_player_attack_dialogue(0)
							elif battle_mouse_num == 0:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 2 and current_attack_locked == false:
									current_attack_locked = true
									_player_attack_dialogue(1)
							elif battle_mouse_num == 1:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3 and current_attack_locked == false: 
									current_attack_locked = true
									_player_attack_dialogue(2)
							elif battle_mouse_num == 2:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4 and current_attack_locked == false:
									current_attack_locked = true
									_player_attack_dialogue(3)