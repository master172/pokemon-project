extends CanvasLayer

onready var Animation_player = $AnimationPlayer

enum states {PC_selection, Pokemon_box, Item_box, Professor_box, Scene, Navigation}

var state = states.Navigation

onready var Home = $Control/Home
onready var Pokemons = $Control/Pokemon

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

"""//////////////////////////////////////////////////////   END  OF  FUNTION  BUTTONS   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"""


var current_pokebox :int = 0

var current_selected :int = 0

var max_selected : int = 6

var animation_playable = true

var controller_active = false

func _input(event):
	if state == states.Pokemon_box:
		if event.is_action_pressed("accept") and controller_active == false:
			controller_active = true
			var cont_box = (Cont_box).instance()
			cont_box.controller = self
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
				Utils.Get_Scene_Manager().transition_exit_Pc()
				queue_free()
	
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
				state = states.Pokemon_box
			current_selected = 0
		elif state == states.Pokemon_box:
			if current_selected != max_selected:
				current_selected += 1
			else:
				current_selected = 0
		
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
					state = states.Navigation
					current_selected = 2
			


		

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
	
