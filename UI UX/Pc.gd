extends CanvasLayer

onready var Animation_player = $AnimationPlayer

enum states {PC_selection, Pokemon_box, Item_box, Professor_box, Scene, Navigation,Party_navigation,Party_selection,Switching_pokemon}

var state = states.Navigation

onready var Home = $Control/Home
onready var Pokemons = $Control/Pokemon
onready var Back_timer = $Back_timer

var selected_pokemon

const Cont_box = preload("res://Ui/Pc_cont_box.tscn")

"""//////////////////////////////////////////////////////   FUNTION  BUTTONS   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"""

#Settings

onready var Settings = $Control/HBoxContainer/Sidebar/VBoxContainer/Bottom_container/Settings
onready var settings_control = $Control/HBoxContainer/Sidebar/VBoxContainer/Bottom_container/Settings/ColorRect
onready var settings_definer = $Control/HBoxContainer/Sidebar/VBoxContainer/Bottom_container/Settings/ColorRect2

#Menu

onready var Menu = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Home
onready var Menu_control = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Home/ColorRect
onready var Menu_definer = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Home/ColorRect2

#Toggle

onready var Toggle = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Toggle
onready var Toggle_control = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Toggle/ColorRect
onready var Toggle_definer = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Toggle/ColorRect2

#Pokemons

onready var Pokemon = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Pokemons
onready var Pokemon_control = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Pokemons/ColorRect
onready var Pokemon_definer = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Pokemons/ColorRect2

#Items

onready var Items = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Items
onready var Items_control = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Items/ColorRect
onready var Items_definer = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Items/ColorRect2

#Call

onready var Call = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Call
onready var Call_control = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Call/ColorRect
onready var Call_definer = $Control/HBoxContainer/Sidebar/VBoxContainer/Top_container/Call/ColorRect2

#PC_BUTTONS

#MY_PC

onready var My_pc = $Control/Home/VBoxContainer/My_pc

#Pokemon_pc

onready var Pokemon_pc = $Control/Home/VBoxContainer/Pokemon_pc

#Call_someone

onready var Call_someone = $Control/Home/VBoxContainer/Call_someone

#Back

onready var Back = $Control/Home/VBoxContainer/Back

#Party_pokemon_1

onready var Party_Pokemon_1 = $Control/Pokemon/Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Left/Pokemon_back_1

#Party_Pokemon_2

onready var Party_Pokemon_2 = $Control/Pokemon/Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Left/Pokemon_back_2

#Party_Pokemon_3

onready var Party_Pokemon_3 = $Control/Pokemon/Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Left/Pokemon_back_3

#Party_Pokemon_4

onready var Party_Pokemon_4 = $Control/Pokemon/Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Right/Pokemon_back_4

#Party_Pokemon_5

onready var Party_Pokemon_5 = $Control/Pokemon/Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Right/Pokemon_back_5

#Party_pokemon_6

onready var Party_Pokemon_6 = $Control/Pokemon/Party/ColorRect/VBoxContainer/HBoxContainer/Party_sprites/Right/Pokemon_back_6

#Deposit

onready var Deposit = $Control/Pokemon/Party/ColorRect/VBoxContainer/Button_box/Deposit 

#Switch

onready var Switch = $Control/Pokemon/Party/ColorRect/VBoxContainer/Button_box/Switch

#Move

onready var Move = $Control/Pokemon/Party/ColorRect/VBoxContainer/Button_box/Move

#Back

onready var Returns = $Control/Pokemon/Party/ColorRect/VBoxContainer/Button_box/Back

"""//////////////////////////////////////////////////////   END  OF  FUNTION  BUTTONS   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"""

var current_to_change

var current_pokebox :int = 0

var current_selected :int = 0

var max_selected : int = 6

var animation_playable = true

var controller_active = false

var cont_box	

var party_wait_timer = false


var temp_pokemon

signal instantated

func _ready():
	Utils.pc = self
	Utils.make_pc_connection()
	emit_signal("instantated")



func _remove_controller():
	if cont_box != null:
		cont_box.queue_free()
		yield(get_tree().create_timer(0.1),"timeout")
		controller_active = false

func _withdraw(selecPokemon):
	selecPokemon.change_path = null
	selecPokemon.change_pc_poke = null
	if PlayerPokemon.second_pokemon == null:
		selecPokemon.change_path = "second_pokemon"
		selecPokemon.change_pc_poke = null		
		PlayerPokemon.second_pokemon = selecPokemon
	elif PlayerPokemon.third_pokemon == null:
		selecPokemon.change_path = "third_pokemon"
		selecPokemon.change_pc_poke = null
		PlayerPokemon.third_pokemon = selecPokemon
	elif PlayerPokemon.fourth_pokemon == null:
		selecPokemon.change_path = "fourth_pokemon"
		selecPokemon.change_pc_poke = null
		PlayerPokemon.fourth_pokemon = selecPokemon
	elif PlayerPokemon.fifth_pokemon == null:
		selecPokemon.change_path = " fifth_pokemon"
		selecPokemon.change_pc_poke = null
		PlayerPokemon.fifth_pokemon = selecPokemon
	elif PlayerPokemon.sixth_pokemon == null:
		selecPokemon.change_path = "sixth_pokemon"
		selecPokemon.change_pc_poke = null
		PlayerPokemon.sixth_pokemon = selecPokemon
	PlayerPokemon.pc_pokemon.erase(selecPokemon)
	Pokemons._update()
	party_wait_timer = true
	state = states.Party_navigation
	current_to_change.color = Color("250080")
	current_selected = current_selected
	Back_timer.start(0.2)
			
func _input(event):
	if state == states.Switching_pokemon:
		max_selected = $Control/Pokemon/ScrollContainer/GridContainer.get_child_count() -1
		if event.is_action_pressed("A"):
			if current_selected == 0:
				state = states.Party_navigation
			else:
				current_selected -= 1
		elif event.is_action_pressed("D"):
			if current_selected != max_selected:
				current_selected += 1
			else:
				current_selected = 0
		if event.is_action_pressed("decline"):
			state = states.Party_selection
		elif event.is_action_pressed("accept"):
			_switch_pokemon(selected_pokemon,PlayerPokemon.pc_pokemon[current_selected])
			state = states.Party_selection
			current_selected = 0
			
	if state == states.Party_selection:
		if event.is_action_pressed("accept"):
			if current_selected == 0:
				Utils.Num_loaded_pokemon += 1
				if selected_pokemon == PlayerPokemon.first_pokemon and PlayerPokemon.first_pokemon != null and PlayerPokemon.second_pokemon != null:
					PlayerPokemon.first_pokemon.change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.first_pokemon.change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.pc_pokemon.append(PlayerPokemon.first_pokemon)
					PlayerPokemon.first_pokemon = PlayerPokemon.second_pokemon
					PlayerPokemon.second_pokemon = PlayerPokemon.third_pokemon
					PlayerPokemon.third_pokemon = PlayerPokemon.fourth_pokemon
					PlayerPokemon.fourth_pokemon = PlayerPokemon.fifth_pokemon
					PlayerPokemon.fifth_pokemon = PlayerPokemon.sixth_pokemon
					PlayerPokemon.sixth_pokemon = null
					$Control/Pokemon._update()
				elif selected_pokemon == PlayerPokemon.second_pokemon and PlayerPokemon.second_pokemon != null:
					PlayerPokemon.second_pokemon.change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.second_pokemon.change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.pc_pokemon.append(PlayerPokemon.second_pokemon)
					PlayerPokemon.second_pokemon = PlayerPokemon.third_pokemon
					PlayerPokemon.third_pokemon = PlayerPokemon.fourth_pokemon
					PlayerPokemon.fourth_pokemon = PlayerPokemon.fifth_pokemon
					PlayerPokemon.fifth_pokemon = PlayerPokemon.sixth_pokemon
					PlayerPokemon.sixth_pokemon = null
					$Control/Pokemon._update()
				elif selected_pokemon == PlayerPokemon.third_pokemon and PlayerPokemon.third_pokemon != null:
					PlayerPokemon.third_pokemon.change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.third_pokemon.change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.pc_pokemon.append(PlayerPokemon.third_pokemon)
					PlayerPokemon.third_pokemon = PlayerPokemon.fourth_pokemon
					PlayerPokemon.fourth_pokemon = PlayerPokemon.fifth_pokemon
					PlayerPokemon.fifth_pokemon = PlayerPokemon.sixth_pokemon
					PlayerPokemon.sixth_pokemon = null
					$Control/Pokemon._update()
				elif selected_pokemon == PlayerPokemon.fourth_pokemon and PlayerPokemon.fourth_pokemon != null:
					PlayerPokemon.fourth_pokemon.change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.fourth_pokemon.change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.pc_pokemon.append(PlayerPokemon.fourth_pokemon)
					PlayerPokemon.fourth_pokemon = PlayerPokemon.fifth_pokemon
					PlayerPokemon.fifth_pokemon = PlayerPokemon.sixth_pokemon
					PlayerPokemon.sixth_pokemon = null
					$Control/Pokemon._update()
				elif selected_pokemon == PlayerPokemon.fifth_pokemon and PlayerPokemon.fifth_pokemon != null:
					PlayerPokemon.fifth_pokemon.change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.fifth_pokemon.change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.pc_pokemon.append(PlayerPokemon.fifth_pokemon)
					PlayerPokemon.fifth_pokemon = PlayerPokemon.sixth_pokemon
					PlayerPokemon.sixth_pokemon = null
					$Control/Pokemon._update()
				elif selected_pokemon == PlayerPokemon.sixth_pokemon  and PlayerPokemon.sixth_pokemon != null:
					PlayerPokemon.sixth_pokemon.change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.sixth_pokemon.change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					PlayerPokemon.pc_pokemon.append(PlayerPokemon.sixth_pokemon)
					PlayerPokemon.sixth_pokemon = null
					$Control/Pokemon._update()
				
				party_wait_timer = true
				state = states.Party_navigation
				current_to_change.color = Color("250080")
				current_selected = 0
				Back_timer.start(0.2)
			if event.is_action_pressed("accept") and current_selected == 3:
				party_wait_timer = true
				current_to_change.color = Color("250080")
				state = states.Party_navigation
				
				current_selected = 0
				Back_timer.start(0.2)
			if event.is_action_pressed("accept") and current_selected == 1 and PlayerPokemon.pc_pokemon.size() > 0:
				_pre_switch()
	
	if event.is_action_pressed("accept") and state == states.Party_navigation and party_wait_timer == false:
		if current_selected == 0:
			selected_pokemon = PlayerPokemon.first_pokemon
		elif current_selected == 1:
			selected_pokemon = PlayerPokemon.second_pokemon
		elif current_selected == 2:
			selected_pokemon = PlayerPokemon.third_pokemon
		elif current_selected == 3:
			selected_pokemon = PlayerPokemon.fourth_pokemon
		elif current_selected == 4:
			selected_pokemon = PlayerPokemon.fifth_pokemon
		elif current_selected == 5:
			selected_pokemon = PlayerPokemon.sixth_pokemon
		state = states.Party_selection
		current_selected = 0

		
	if state == states.Pokemon_box:
		if event.is_action_pressed("accept") and controller_active == false:
			controller_active = true
			cont_box = (Cont_box).instance()
			cont_box.controller = self
			cont_box.selected_pokemon = PlayerPokemon.pc_pokemon[current_selected]
			self.add_child(cont_box)
		
	if state == states.PC_selection:
		if event.is_action_pressed("accept"):
			if current_selected == 0:
				state = states.Navigation
				current_selected = 3
			elif current_selected == 1:
				state = states.Navigation
				current_selected = 2
			elif current_selected == 2:
				state = states.Navigation
				current_selected = 4
			elif current_selected == 3:
				Utils.destroy_pc_connection()
				get_tree().change_scene_to(load("res://Scenes/SceneManager.tscn"))
	
	if event.is_action_pressed("W"):
		if state != states.Pokemon_box:
			if current_selected != max_selected:
				current_selected = current_selected + 1
			else:
				current_selected = 0

	elif event.is_action_pressed("S"):
		if state != states.Pokemon_box:
			if current_selected != 0:
				current_selected = current_selected - 1
			else:
				current_selected = max_selected

	if event.is_action_pressed("D"):
		if state == states.Navigation:
			if current_selected == 0:
				pass
			elif current_selected == 1:
				state = states.PC_selection
			elif current_selected == 2:
				state = states.Party_navigation
			current_selected = 0
		elif state == states.Pokemon_box:
			if current_selected != max_selected:
				current_selected += 1
			else:
				current_selected = 0
		
		elif state == states.Party_navigation:
			if (current_selected == 3 or current_selected == 4 or current_selected == 5) and PlayerPokemon.pc_pokemon.size() > 0:
				state = states.Pokemon_box
				current_selected = 0
				current_to_change.color = Color("250080")
			elif current_selected == 0:
				current_selected = 4
			elif current_selected == 1:
				current_selected = 5
			elif current_selected == 2:
				current_selected = 3
		
	if event.is_action_pressed("A"):
		if !state == states.Navigation:
			if state == states.PC_selection:
				state = states.Navigation
				current_selected = 1
				_reset_pc_Selection()
			elif state == states.Pokemon_box:
				if current_selected != 0:
					current_selected -= 1
				elif current_selected == 0:
					for i in $Control/Pokemon/ScrollContainer/GridContainer.get_child_count():
						$Control/Pokemon/ScrollContainer/GridContainer.get_child(i).selected = false
					state = states.Party_navigation
					current_selected = 0
					
			elif state == states.Party_navigation:
				if current_selected == 0 or current_selected == 1 or current_selected == 2 or current_selected == 6 or current_selected == 7 or current_selected == 8 or current_selected == 9:
					state = states.Navigation
					current_selected = 2
					current_to_change.color = Color("250080")
				elif current_selected == 3:
					current_selected = 0
				elif current_selected == 4:
					current_selected = 1
				elif current_selected == 5:
					current_selected = 2
	
	if event.is_action_pressed("decline"):
		if state == states.Party_selection:
			state = states.Party_navigation
			current_to_change.color = Color("250080")
			current_selected = 0
		
func _pre_switch():
	state = states.Switching_pokemon
	current_selected = 0
	
			
func _switch_pokemon(pokemon_1,pokemon_2):

	PlayerPokemon._switch(pokemon_1,pokemon_2)
	$Control/Pokemon._update()
	pokemon_1 = null
	pokemon_2 = null
	Utils._set_pc_reload_data(states.Party_navigation,current_selected)
	get_tree().reload_current_scene()


func _function():
	if state == states.Navigation:
		if current_selected == 0:
			Home.visible = false
			Pokemons.visible = false
		elif current_selected == 1:
			Home.visible = true
			Pokemons.visible = false
		elif current_selected == 2:
			Home.visible = false
			Pokemons.visible = true
		elif current_selected == 3:
			Home.visible = false
			Pokemons.visible = false
		elif current_selected == 4:
			Home.visible = false
			Pokemons.visible = false
		elif current_selected == 5:
			Home.visible = false
			Pokemons.visible = false

func _reset_pc_Selection():
	My_pc.color = Color("0b042a")
	Pokemon_pc.color = Color("0b042a")
	Call_someone.color = Color("0b042a")
	Back.color = Color("0b042a")


func _physics_process(_delta):
	if state == states.Switching_pokemon:
		if Input.is_action_pressed("W"):
			$Control/Pokemon/ScrollContainer.scroll_vertical += 1
		elif Input.is_action_pressed("S"):
			$Control/Pokemon/ScrollContainer.scroll_vertical -= 1
		max_selected = $Control/Pokemon/ScrollContainer/GridContainer.get_child_count() -1
		for i in $Control/Pokemon/ScrollContainer/GridContainer.get_child_count():
			if $Control/Pokemon/ScrollContainer/GridContainer.get_child(i).num == current_selected:
				$Control/Pokemon/ScrollContainer/GridContainer.get_child(i).selected = true
			else:
				$Control/Pokemon/ScrollContainer/GridContainer.get_child(i).selected = false
	if state == states.Pokemon_box:
		if Input.is_action_pressed("W"):
			$Control/Pokemon/ScrollContainer.scroll_vertical += 1
		elif Input.is_action_pressed("S"):
			$Control/Pokemon/ScrollContainer.scroll_vertical -= 1
		max_selected = $Control/Pokemon/ScrollContainer/GridContainer.get_child_count() -1
		for i in $Control/Pokemon/ScrollContainer/GridContainer.get_child_count():
			if $Control/Pokemon/ScrollContainer/GridContainer.get_child(i).num == current_selected:
				$Control/Pokemon/ScrollContainer/GridContainer.get_child(i).selected = true
			else:
				$Control/Pokemon/ScrollContainer/GridContainer.get_child(i).selected = false

	_function()

	if state == states.Navigation and current_selected == 0:
		if animation_playable == true:
			Animation_player.play("Side_bar_anim")
			animation_playable = false
		max_selected = 5
	
	else:
		if animation_playable == false:
			Animation_player.play_backwards("Side_bar_anim")
			animation_playable = true
		
	if current_selected == 0 and state == states.Navigation:
		Toggle_control.color = Color("b8ff00b9")
		Toggle_definer.color = Color("ff00b9")
	elif current_selected != 0 and state == states.Navigation:
		Toggle_control.color = Color("0b042a")
		Toggle_definer.color = Color("00ffffff")
	if current_selected == 1 and state == states.Navigation:
		Menu_control.color = Color("b8ff00b9")
		Menu_definer.color = Color("ff00b9")
	elif current_selected != 1 and state == states.Navigation:
		Menu_control.color = Color("0b042a")
		Menu_definer.color = Color("00ffffff")
	if current_selected == 2 and state == states.Navigation:
		Pokemon_control.color = Color("b8ff00b9")
		Pokemon_definer.color = Color("ff00b9")
	elif current_selected != 2 and state == states.Navigation:
		Pokemon_control.color = Color("0b042a")
		Pokemon_definer.color = Color("00ffffff")	
	if current_selected == 3 and state == states.Navigation:
		Items_control.color = Color("b8ff00b9")
		Items_definer.color = Color("ff00b9")
	elif current_selected != 3 and state == states.Navigation:
		Items_control.color = Color("0b042a")
		Items_definer.color = Color("00ffffff")
	if current_selected == 4 and state == states.Navigation:
		Call_control.color = Color("b8ff00b9")
		Call_definer.color = Color("ff00b9")
	elif current_selected != 4 and state == states.Navigation:
		Call_control.color = Color("0b042a")
		Call_definer.color = Color("00ffffff")		
	if current_selected == 5 and state == states.Navigation:
		settings_control.color = Color("b8ff00b9")
		settings_definer.color = Color("ff00b9")
	elif current_selected != 5 and state == states.Navigation:
		settings_control.color = Color("0b042a")
		settings_definer.color = Color("00ffffff")
	
	if state == states.PC_selection:
		max_selected = 3
		if current_selected == 0:
			My_pc.color = Color("b8ff00b9")
		else:
			My_pc.color = Color("0b042a")
		if current_selected == 1:
			Pokemon_pc.color = Color("b8ff00b9")
		else:
			Pokemon_pc.color = Color("0b042a")
		if current_selected == 2:
			Call_someone.color = Color("b8ff00b9")
		else:
			Call_someone.color = Color("0b042a")
		if current_selected == 3:
			Back.color = Color("b8ff00b9")
		else:
			Back.color = Color("0b042a")
	
	if state == states.Party_navigation:
		max_selected = 5
		if current_selected == 0:
			Party_Pokemon_1.color = Color("17bcc8")
			current_to_change = Party_Pokemon_1
		else:
			Party_Pokemon_1.color = Color("250080")	
		if current_selected == 1:
			Party_Pokemon_2.color = Color("17bcc8")
			current_to_change = Party_Pokemon_2
		else:
			Party_Pokemon_2.color = Color("250080")
		if current_selected == 2:
			Party_Pokemon_3.color = Color("17bcc8")
			current_to_change = Party_Pokemon_3
		else:
			Party_Pokemon_3.color = Color("250080")
		if current_selected == 3:
			Party_Pokemon_4.color = Color("17bcc8")
			current_to_change = Party_Pokemon_4
		else:
			Party_Pokemon_4.color = Color("250080")
		if current_selected == 4:
			Party_Pokemon_5.color = Color("17bcc8")
			current_to_change = Party_Pokemon_5
		else:
			Party_Pokemon_5.color = Color("250080")
		if current_selected == 5:
			Party_Pokemon_6.color = Color("17bcc8")
			current_to_change = Party_Pokemon_6
		else:
			Party_Pokemon_6.color = Color("250080")
		
	if state == states.Party_selection:
		max_selected = 3
		if current_selected == 0:
			Deposit.color = Color("17bcc8")
			current_to_change = Deposit
		else:
			Deposit.color = Color("250080")
		if current_selected == 1:
			Switch.color = Color("17bcc8")
			current_to_change = Switch
		else:
			Switch.color = Color("250080")
		if current_selected == 2:
			Move.color = Color("17bcc8")
			current_to_change = Move
		else:
			Move.color = Color("250080")
		if current_selected == 3:
			Returns.color = Color("17bcc8")
			current_to_change = Returns
		else:
			Returns.color = Color("250080")
		


func _on_Back_timer_timeout():
	party_wait_timer = false
