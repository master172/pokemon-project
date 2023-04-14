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

var trainer_level_up_dialogue_connected = false

var current_attack_locked = false

var lose_oneshot = false

var learning_a_move = false

var win_exp_points

var to_level_up = false
var to_level_up_level = 0

var pokemon_index = 0
var level_up_index = 0

signal playerDialogueFinished

var to_player_attack = false
var to_enemy_attack = false

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
		if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
			ui_state = Ui_state.Battle
			OpposingTrainerMonsters.pokemon._wild_battle_attack()
			if BattleManager.EnemyLastMoveEvaded == true:
				ui_state = Ui_state.Dialogue
				_enemy_attack_evaded()
			elif BattleManager.EnemyLastMoveMissed == true:
				ui_state = Ui_state.Dialogue
				_enemy_attack_missed()
			elif BattleManager.EnemyLastMoveEvaded == false and BattleManager.EnemyLastMoveMissed == false:
				current_attack_locked = false
		elif BattleManager.type_of_battle ==BattleManager.types_of_battle.Trainer:
			ui_state = Ui_state.Battle
			OpposingTrainerMonsters.pokemon._trainer_battle_attack()
			if BattleManager.EnemyLastMoveEvaded == true:
				ui_state = Ui_state.Dialogue
				_enemy_attack_evaded()
			elif BattleManager.EnemyLastMoveMissed == true:
				ui_state = Ui_state.Dialogue
				_enemy_attack_missed()
			elif BattleManager.EnemyLastMoveEvaded == false and BattleManager.EnemyLastMoveMissed == false:
				current_attack_locked = false
	to_enemy_attack = false

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
	yield(get_tree().create_timer(0.1),"timeout")
	if Dialogue_layer.get_child_count() > 0:
		
		if self.get_child(0).current_event != null:
			yield(self.get_child(0),'finished_event')
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name + " used "+move.Name, 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_finish_player_attack_dialogue")
	else:
		var Dialogue = Dialog.instance()
		Dialogue.text_to_diaplay = [PlayerPokemon.current_pokemon.Name + " used "+move.Name, 0]
		Dialogue_layer.add_child(Dialogue)
		Dialogue.connect("Dialog_ended",self,"_finish_player_attack_dialogue")

func _finish_player_attack_dialogue():
	
	ui_state = Ui_state.Battle
	emit_signal("playerDialogueFinished")
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
						to_player_attack = false
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"_lose_process")
				else:
					var Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [ PlayerPokemon.current_pokemon.Name + " fainted", 0]
					to_player_attack = false
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
			if OpposingTrainerMonsters.get_child_count() > 0:
				enemy_pokemon = OpposingTrainerMonsters.pokemon
				if enemy_dialogue_connected == false:

					OpposingTrainerMonsters.pokemon.connect("Enemy_attacked",self,"_display_enemy_attack_dialogue")
					enemy_dialogue_connected = true
				if enemy_lost_dialogue_connected == false:
					OpposingTrainerMonsters.pokemon.connect("enemy_lost",self,"_win_dialog_process_dailog")
					enemy_lost_dialogue_connected = true
				opposing_pokemon_sprite.texture = enemy_pokemon.sprite
			else:
				enemy_pokemon = null
				opposing_pokemon_sprite.texture = null

		if BattleManager.processing == false:
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
			if BattleManager.processing == false:
				if Input.is_action_just_pressed("accept") and Dialogue_layer.get_child_count() == 0:
					print("yo")
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
									PlayerPokemon.current_pokemon.Learned_moves[0]._check_speed()
							elif battle_mouse_num == 0:
								print("yo2")
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 2 and current_attack_locked == false:
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[1]._check_speed()
							elif battle_mouse_num == 1:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3 and current_attack_locked == false: 
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[2]._check_speed()
							elif battle_mouse_num == 2:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4 and current_attack_locked == false:
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[3]._check_speed()
			
					
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

func _win_dialog_process_dailog():
	print("etf")
	ui_state = Ui_state.Dialogue
	var Dialogue

	Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name, 0]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("Dialog_ended",self,"_win_dialog_process")


func _win_dialog_process():
	pokemon_index += 1

	if pokemon_index - 1 == BattleManager.BatteledPokemon.size():
		print("k")
		_level_up_process()
	else:
		print("k2")
		_win_dialog((pokemon_index-1),BattleManager.BatteledPokemon[pokemon_index-1])

func _level_up_process():
	level_up_index += 1

	if BattleManager.BatteledLevelPokemon.size() > 0:
		if level_up_index - 1 == BattleManager.BatteledLevelPokemon.size():
			win()
			
		else:
			_level_up_dialog(level_up_index - 1)
	else:
		win()

func _level_up_dialog(i):
	var Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = [BattleManager.BatteledLevelPokemon[i].Name + " leveled up to level " + String(BattleManager.BatteledLevelUp[i]),0]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("Dialog_ended",self,"_resume_level_up")

func _resume_level_up():
	_level_up_process()
	
func _win_dialog(index,Pokemon = PlayerPokemon.first_pokemon):
	var Dialogue
	var exp_points
	yield(get_tree().create_timer(0.2),"timeout")
	exp_points = BattleManager.BatteledExperiece[index]
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		if exp_points != 0:
			win_exp_points = exp_points

		yield(get_tree().create_timer(0.2),"timeout")
		if learning_a_move == false and Dialogue_layer.get_child_count() == 0:
			if exp_points != 0:
					
				Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_win_dialog_process")
			elif exp_points == 0:
				Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(win_exp_points))+ " experience points"), 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_win_dialog_process")
				win_exp_points = 0
		elif learning_a_move == false and Dialogue_layer.get_child_count() > 0:
			if self.get_child(0).current_event != null:
				yield(self.get_child(0),'finished_event')
				if exp_points != 0:
						
					Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_win_dialog_process")
				elif exp_points == 0:
					Dialogue = Dialog.instance()
					Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(win_exp_points))+ " experience points"), 0]
					Dialogue_layer.add_child(Dialogue)
					Dialogue.connect("Dialog_ended",self,"_win_dialog_process")
					win_exp_points = 0
		elif learning_a_move == true:
			StartMoveLearnDialogue(MoveLearner.move_to_learn)
		

func _single_battle_win_dialog(index,Pokemon = PlayerPokemon.first_pokemon):
	var Dialogue
	var exp_points
	exp_points = BattleManager.BatteledExperiece[index]
	if exp_points != 0:
		print_debug("win_exp_points")
		win_exp_points = exp_points

	yield(get_tree().create_timer(0.2),"timeout")

	if learning_a_move == false and Dialogue_layer.get_child_count() == 0:
		print_debug("case 1.0")
		if exp_points != 0:
			print_debug("case 1.1")
			Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_check_win")
		elif exp_points == 0:
			print_debug("case 1.2")
			Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(win_exp_points))+ " experience points"), 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_check_win")
			win_exp_points = 0
	elif learning_a_move == false and Dialogue_layer.get_child_count() > 0:
		print_debug("case 2.0")
		if self.get_child(0).current_event != null:
			print_debug("case 2.1.0")
			yield(self.get_child(0),'finished_event')
			if exp_points != 0:
				print_debug("case 2.2")
				Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(exp_points))+ " experience points"), 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_check_win")
			elif exp_points == 0:
				print_debug("case 2.3")
				Dialogue = Dialog.instance()
				Dialogue.text_to_diaplay = [String(Pokemon.Name + " gained "+ String(int(win_exp_points))+ " experience points"), 0]
				Dialogue_layer.add_child(Dialogue)
				Dialogue.connect("Dialog_ended",self,"_check_win")
				win_exp_points = 0
	elif learning_a_move == true:
		print_debug("case 2.1.1")
		StartMoveLearnDialogue(MoveLearner.move_to_learn)


func _check_win_dialog():
	ui_state = Ui_state.Dialogue
	var Dialogue

	Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = ["Ash defeated the opposing "+OpposingTrainerMonsters.pokemon.Name, 0]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("Dialog_ended",self,"_check_win")

func _check_win():
	
	pokemon_index += 1

	if pokemon_index -1 == BattleManager.BatteledPokemon.size():
		print("k1")
		_level_up_process_trainer()
	else:
		print("k2")
		_single_battle_win_dialog((pokemon_index-1),BattleManager.BatteledPokemon[pokemon_index-1])

func _level_up_process_trainer():
	level_up_index += 1

	if BattleManager.BatteledLevelPokemon.size() > 0:
		if level_up_index - 1 == BattleManager.BatteledLevelPokemon.size():
			_check_win_process()
		else:
			_level_up_dialog_trainer(level_up_index - 1)
			
	else:
		_check_win_process()

func _level_up_dialog_trainer(i):
	var Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = [BattleManager.BatteledLevelPokemon[i].Name + " leveled up to level " + String(BattleManager.BatteledLevelUp[i]),0]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("Dialog_ended",self,"_resume_level_up_trainer")

func _resume_level_up_trainer():
	_level_up_process_trainer()

func _check_win_process():
	pokemon_index = 0
	OpposingTrainerMonsters._remove_children()
	OpposingTrainerMonsters.pokemons.remove(0)
	if OpposingTrainerMonsters.pokemons.size() > 0:
		ui_state = Ui_state.Dialogue
		_change_opposing_pokemon()
	else:
		win()


func _change_opposing_pokemon():
	if BattleManager.multi_battle == false:
		if ui_state == Ui_state.Dialogue:
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["the opposing trainer sended his next pokemon", 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_change_opposing_pokemon_progress")

func _change_opposing_pokemon_progress():
	OpposingTrainerMonsters.pokemon = null
	if BattleManager.multi_battle == false:
		if OpposingTrainerMonsters.pokemons.size() > 0:
			OpposingTrainerMonsters.active_trainers[0]._add_pokemon(0) 
			enemy_dialogue_connected = false
			enemy_lost_dialogue_connected = false

	ui_state = Ui_state.Battle
	
func _attack_inp():
	ui_state = Ui_state.Battle


func win():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:

		BattleManager.BatteledPokemon = []
		BattleManager.BatteledExperiece = []
		BattleManager.BatteledLevelUp = []
		BattleManager.BatteledLevelPokemon = []

		pokemon_index = 0
		level_up_index = 0
		Utils.Num_loaded_pokemon -= 1
		enemy_dialogue_connected = false
		enemy_lost_dialogue_connected = false
		OpposingTrainerMonsters._remove_children()
		BattleManager.fainted = true
		Utils.Get_Scene_Manager().transition_exit_pokemon_scene()
	elif BattleManager.type_of_battle ==BattleManager.types_of_battle.Trainer:
		if BattleManager.multi_battle == false:

			pokemon_index = 0
			level_up_index = 0

			BattleManager.BatteledPokemon = []
			BattleManager.BatteledExperiece = []
			BattleManager.BatteledLevelUp = []
			BattleManager.BatteledLevelPokemon = []

			Utils.Num_loaded_pokemon -= 1

			ui_state = Ui_state.Dialogue
			var Dialogue = Dialog.instance()
			Dialogue.text_to_diaplay = ["Ash defeated the opposing trainer", 0]
			Dialogue_layer.add_child(Dialogue)
			Dialogue.connect("Dialog_ended",self,"_trainer_complete_win")
	
func _trainer_complete_win():
	enemy_dialogue_connected = false
	enemy_lost_dialogue_connected = false
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
	else:
		ui_state = Ui_state.Dialogue
		var Dialogue = Dialog.instance()
		Dialogue.text_to_diaplay = ["Can't capture an trainers pokemon", 0]
		Dialogue_layer.add_child(Dialogue)
		Dialogue.connect("Dialog_ended",self,"_trainer_complete_win")
		ui_state = Ui_state.Battle

func _run():
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		Utils.Num_loaded_pokemon -= 1
		Utils.Get_Scene_Manager().transition_exit_pokemon_scene()
		OpposingTrainerMonsters.pokemon = null
		OpposingTrainerMonsters._remove_children()
		PlayerPokemon.current_pokemon = null
		
	else:
		ui_state = Ui_state.Dialogue
		var Dialogue = Dialog.instance()
		Dialogue.text_to_diaplay = ["Can't run from a trainer battle", 0]
		Dialogue_layer.add_child(Dialogue)
		ui_state = Ui_state.Battle

func _input(event):
	if BattleManager.processing == false:
		if BattleManager.multi_battle == false:
			if event.is_pressed():
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
					print("the fuck")
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
						print("the fuck")
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
	if MoveLearner.target_pokemon.get_parent() == PlayerPokemon:
		if ui_state == Ui_state.Dialogue:
			if BattleManager.multi_battle == false:
				if MoveLearner.target_pokemon != null:
					if Dialogue_layer.get_child_count() > 0:
						if self.get_child(0).current_event != null:
							yield(self.get_child(0),'finished_event')
							print_debug("cause 1.0")
							learning_a_move = true
							var Dialogue = Dialog.instance()
							Dialogue.text_to_diaplay = [MoveLearner.target_pokemon.Name +" wants to learn " + move.Name," how ever "+ MoveLearner.target_pokemon.Name + " already knows four moves please choose what to do", 0]
							Dialogue_layer.add_child(Dialogue)
							Dialogue.connect("Dialog_ended",self,"MoveLearningProcess")
					else:
						learning_a_move = true
						print_debug("cause 2.0")
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = [MoveLearner.target_pokemon.Name +" wants to learn " + move.Name," how ever "+ MoveLearner.target_pokemon.Name + " already knows four moves please choose what to do", 0]
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
			_win_dialog_process()	

func StartMoveLearnDialogue(move):
	if MoveLearner.target_pokemon.get_parent() == PlayerPokemon:
		if ui_state == Ui_state.Dialogue:
			if BattleManager.multi_battle == false:
				if MoveLearner.target_pokemon != null:
					if Dialogue_layer.get_child_count() > 0:
						yield(get_tree().create_timer(1),"timeout")
						if self.get_child(0).current_event != null:
							yield(self.get_child(0),'finished_event')
							print_debug("cause 3.0")
							learning_a_move = true
							var Dialogue = Dialog.instance()
							Dialogue.text_to_diaplay = [MoveLearner.target_pokemon.Name +" learned " + move.Name, 0]
							Dialogue_layer.add_child(Dialogue)
							Dialogue.connect("Dialog_ended",self,"StartMoveLearnProcess")
					else:
						var Dialogue = Dialog.instance()
						Dialogue.text_to_diaplay = [MoveLearner.target_pokemon.Name +" learned " + move.Name, 0]
						Dialogue_layer.add_child(Dialogue)
						Dialogue.connect("Dialog_ended",self,"StartMoveLearnProcess")
	
func StartMoveLearnProcess():
	learning_a_move = false
	if BattleManager.multi_battle == false:
		if PlayerPokemon.current_pokemon != null:
			_win_dialog_process()

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
			if OpposingTrainerMonsters.get_child_count() > 0:
				enemy_pokemon = OpposingTrainerMonsters.pokemon
				if enemy_dialogue_connected == false:

					OpposingTrainerMonsters.pokemon.connect("Enemy_attacked",self,"_display_enemy_attack_dialogue")
					enemy_dialogue_connected = true
				if enemy_lost_dialogue_connected == false:
					OpposingTrainerMonsters.pokemon.connect("enemy_lost",self,"_check_win_dialog")
					enemy_lost_dialogue_connected = true
				opposing_pokemon_sprite.texture = enemy_pokemon.sprite
		else:
			enemy_pokemon = null
			opposing_pokemon_sprite.texture = null

		if BattleManager.processing == false:
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
			if BattleManager.processing == false:
				if Input.is_action_just_pressed("accept") and Dialogue_layer.get_child_count() == 0:
					print("2")
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
							print("3")
							if battle_mouse_num == 3:
								ui_state = Ui_state.Main
							elif battle_mouse_num == 4:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 1 and current_attack_locked == false:
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[0]._check_speed()
							elif battle_mouse_num == 0:
								print("4")
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 2 and current_attack_locked == false:
									print("5")
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[1]._check_speed()
							elif battle_mouse_num == 1:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3 and current_attack_locked == false: 
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[2]._check_speed()
							elif battle_mouse_num == 2:
								if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4 and current_attack_locked == false:
									current_attack_locked = true
									PlayerPokemon.current_pokemon.Learned_moves[3]._check_speed()

func enemy_turn():
	to_enemy_attack = true

func _on_Tween_tween_completed(object, key):
	if object == get_node("Battle_identifier/Player_pokemon_0/HealthBar"):
		if to_player_attack == false:
			ui_state = Ui_state.Battle
			to_player_attack = true
		elif to_player_attack == true:
			BattleManager.Generate_moves()
	elif object == get_node("Battle_identifier/Enemy_pokemon_0/HealthBar"):
		if to_enemy_attack == true:
			if OpposingTrainerMonsters.pokemon.fainted == false:
				_display_enemy_attack_dialogue(OpposingTrainerMonsters.movesToGo[0],OpposingTrainerMonsters.movesToGo[1])
			else:
				to_enemy_attack = false
				BattleManager.processing = false
				current_attack_locked = false
		elif to_enemy_attack == false:
			if PlayerPokemon.current_pokemon != null:
				ui_state = Ui_state.Battle
				BattleManager.Generate_moves()

func _enemy_start_attack():
	print("yo3")
	if to_enemy_attack == true:
		if OpposingTrainerMonsters.pokemon.fainted == false:
			_display_enemy_attack_dialogue(OpposingTrainerMonsters.movesToGo[0],OpposingTrainerMonsters.movesToGo[1])
		else:
			to_enemy_attack = false
			BattleManager.processing = false
			current_attack_locked = false

func _enmy_first_attack(move):
	if to_enemy_attack == true:
		if OpposingTrainerMonsters.pokemon.fainted == false:
			_display_enemy_attack_dialogue(OpposingTrainerMonsters.movesToGo[0],OpposingTrainerMonsters.movesToGo[1])
		else:
			to_enemy_attack = false
			BattleManager.processing = false
			current_attack_locked = false