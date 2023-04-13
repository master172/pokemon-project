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


onready var learn = $Forgetter/Buttons/Learn/Selected
onready var info = $Forgetter/Buttons/Info/Selected
onready var forget = $Forgetter/Buttons/Forget/Selected
onready var back = $Forgetter/Buttons/Back/Selected

onready var move_to_learn = $Forgetter/Move/Selected
onready var move_to_learn_Name = $Forgetter/Move/Name

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
		elif event.is_action_pressed("decline"):
			MoveLearner._cancel_learning()
			selected_option = 0
			move_selected = 0
			current_pokemon = null
			



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
				if selected_option == 0: # selecting the learn option
					pass
				elif selected_option == 1: #Selecting the forget option
					if move_selected == 0:
						MoveLearner._make_to_learn(0,MoveLearner.target_pokemon.Learned_moves[0])
						
						current_pokemon = null

					elif move_selected == 1:
						MoveLearner._make_to_learn(1,MoveLearner.target_pokemon.Learned_moves[1])	
						
						current_pokemon = null

					elif move_selected == 2:
						MoveLearner._make_to_learn(2,MoveLearner.target_pokemon.Learned_moves[2])
						
						current_pokemon = null

					elif move_selected == 3:
						MoveLearner._make_to_learn(3,MoveLearner.target_pokemon.Learned_moves[3])
						
						current_pokemon = null

					elif move_selected == 4:
						MoveLearner._cancel_learning()
						
						current_pokemon = null

				elif selected_option == 2: #selecting the info option
					pass
				elif selected_option == 3: #selecting the back option
					current_option = Options.Selection
					selected_option = 0
		



func _physics_process(_delta):
	if self.current_pokemon != null:
		if current_pokemon.Learned_moves.size() >= 1:
			Move_1_Name.text = current_pokemon.Learned_moves[0].name
		if current_pokemon.Learned_moves.size() >- 2:
			Move_2_Name.text = current_pokemon.Learned_moves[1].name
		if current_pokemon.Learned_moves.size () >=  3:
			Move_3_Name.text = current_pokemon.Learned_moves[2].name
		if current_pokemon.Learned_moves.size() >= 4:
			Move_4_Name.text = current_pokemon.Learned_moves[3].name
		if MoveLearner.move_to_learn != null:
			move_to_learn_Name.text = MoveLearner.move_to_learn.name
	if current_option == Options.Main:
		visible = false
	elif current_option == Options.Selection:
		visible = true
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
	
	elif current_option == Options.Options:
		self.visible = true
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
	else:
		self.visible = false
	
