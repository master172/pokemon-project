extends Control

enum Options {Main,Selection,Options}

var current_option = Options.Main

var selected_option = 0

var move_selected

var current_pokemon

onready var Move_1_selection = $Move_container/Move1/Selected
onready var Move_2_selection = $Move_container/Move2/Selected
onready var Move_3_selection = $Move_container/Move3/Selected
onready var Move_4_selection = $Move_container/Move4/Selected

onready var Move_1_Name = $Move_container/Move1/Name
onready var Move_2_Name = $Move_container/Move2/Name
onready var Move_3_Name = $Move_container/Move3/Name
onready var Move_4_Name = $Move_container/Move4/Name

onready var Move_1_Description = $Move_container/Move1/Description
onready var Move_2_Description = $Move_container/Move2/Description
onready var Move_3_Description = $Move_container/Move3/Description
onready var Move_4_Description = $Move_container/Move4/Description

onready var learn = $Forgetter/Buttons/Learn/Selected
onready var info = $Forgetter/Buttons/Info/Selected
onready var forget = $Forgetter/Buttons/Forget/Selected
onready var back = $Forgetter/Buttons/Back/Selected

onready var move_to_learn = $Forgetter/Move/Selected
onready var move_to_learn_Name = $Forgetter/Move/Name
onready var move_to_learn_Description = $Forgetter/Move/Description

func _ready():
	pass

func _input(event):
	if current_option == Options.Selection:

		learn.frame = 0
		forget.frame = 0
		info.frame = 0
		back.frame = 0
		
		if event.is_action_pressed("W"):
				if selected_option == 4:
					selected_option = 0
				else:
					selected_option += 1
		elif event.is_action_pressed("S"):
				if selected_option == 0:
					selected_option = 4
				else:
					selected_option -= 1
		elif event.is_action_pressed("A"):
				if selected_option == 0:
					selected_option = 4
				else:
					selected_option -= 1
		elif event.is_action_pressed("D"):
				if selected_option == 4:
					selected_option = 0
				else:
					selected_option += 1
		elif event.is_action_pressed("accept"):
			move_selected = selected_option
			current_option = Options.Options
			selected_option = 0



	elif current_option == Options.Options:

		Move_1_selection.frame = 0
		Move_2_selection.frame = 0
		Move_3_selection.frame = 0
		Move_4_selection.frame = 0

		move_to_learn.frame = 0

		if event.is_action_pressed("W"):
			if selected_option == 3:
				selected_option = 0
			else:
				selected_option += 1
		elif event.is_action_pressed("S"):
				if selected_option == 0:
					selected_option = 3
				else:
					selected_option -= 1
		elif event.is_action_pressed("A"):
				if selected_option == 0:
					selected_option = 3
				else:
					selected_option -= 1
		elif event.is_action_pressed("D"):
				if selected_option == 3:
					selected_option = 0
				else:
					selected_option += 1
		elif event.is_action_pressed("accept"):
				if selected_option == 0:
					current_option = Options.Main
				elif selected_option == 1:
					if move_selected == 0:
						MoveLearner._make_to_learn(0,MoveLearner.target_pokemon.Learned_moves[0])
					elif move_selected == 1:
						MoveLearner._make_to_learn(1,MoveLearner.target_pokemon.Learned_moves[1])	
					elif move_selected == 2:
						MoveLearner._make_to_learn(2,MoveLearner.target_pokemon.Learned_moves[2])	
					elif move_selected == 3:
						MoveLearner._make_to_learn(3,MoveLearner.target_pokemon.Learned_moves[3])	
				elif selected_option == 2:
					pass
				elif selected_option == 3:
					current_option = Options.Selection
					selected_option = 0
		



func _physics_process(_delta):
	if self.current_pokemon != null:
		if current_pokemon.Learned_moves.size > 0:
			Move_1_Name = current_pokemon.Learned_moves[0].name
			Move_1_Description = current_pokemon.Learned_moves[0].description
		if current_pokemon.Learned_movessize > 1:
			Move_2_Name = current_pokemon.Learned_moves[1].name
			Move_2_Description = current_pokemon.Learned_moves[1].description
		if current_pokemon.Learned_movessize > 2:
			Move_3_Name = current_pokemon.Learned_moves[2].name
			Move_3_Description = current_pokemon.Learned_moves[2].description
		if current_pokemon.Learned_movessize > 3:
			Move_4_Name = current_pokemon.Learned_moves[3].name
			Move_4_Description = current_pokemon.Learned_moves[3].description
		if MoveLearner.move_to_learn != null:
			move_to_learn_Name = MoveLearner.move_to_learn.name
			move_to_learn_Description = MoveLearner.move_to_learn.description
	if current_option == Options.Main:
		visible = false
	else:
		visible = true
	if current_option == Options.Selection:
		if selected_option == 0:
			Move_1_selection.frame = 1
		else:
			Move_1_selection.frame = 0

		if selected_option == 1:
			Move_2_selection.frame = 1
		else:
			Move_2_selection.frame = 0

		if selected_option == 2:
			Move_3_selection.frame = 1
		else:
			Move_3_selection.frame = 0

		if selected_option == 3:
			Move_4_selection.frame = 1
		else:
			Move_4_selection.frame = 0
		
		if selected_option == 4:
			move_to_learn.frame = 1
		else:
			move_to_learn.frame = 0
	
	if current_option == Options.Options:
		if selected_option == 0:
			learn.frame = 1
		else:
			learn.frame = 0

		if selected_option == 1:
			forget.frame = 1
		else:
			forget.frame = 0

		if selected_option == 2:
			info.frame = 1
		else:
			info.frame = 0

		if selected_option == 3:
			back.frame = 1
		else:
			back.frame = 0