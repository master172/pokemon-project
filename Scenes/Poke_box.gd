extends Control

var pokemon_selected = false

var current_selected:int = 1

var can_select = false

const main_sprite = preload("res://assests/items/pngwing.com.png")
const SecondarySprite = preload("res://assests/items/clipart1298464 (1).png")

onready var Pokeball_1 = $Poke_selector/HBoxContainer/Poke_ball_1
onready var Pokeball_2 = $Poke_selector/HBoxContainer/Poke_ball_2
onready var Pokeball_3 = $Poke_selector/HBoxContainer/Poke_ball_3
onready var Pokeball_4 = $Poke_selector/HBoxContainer/Poke_ball_4
onready var Pokeball_5 = $Poke_selector/HBoxContainer/Poke_ball_5
onready var Pokeball_6 = $Poke_selector/HBoxContainer/Poke_ball_6

onready var Pokemon_1 = $Poke_selector/HBoxContainer/Poke_ball_1/Pokemon_sprite
onready var Pokemon_2 = $Poke_selector/HBoxContainer/Poke_ball_2/Pokemon_sprite
onready var Pokemon_3 = $Poke_selector/HBoxContainer/Poke_ball_3/Pokemon_sprite
onready var Pokemon_4 = $Poke_selector/HBoxContainer/Poke_ball_4/Pokemon_sprite
onready var Pokemon_5 = $Poke_selector/HBoxContainer/Poke_ball_5/Pokemon_sprite
onready var Pokemon_6 = $Poke_selector/HBoxContainer/Poke_ball_6/Pokemon_sprite

var Dialogue


func _ready():
	visible = true
func _kill():
	pokemon_selected = true
	visible= false

func _say_choosing_dialogue(pokemon):
	can_select = false
	pokemon_selected = true
	self.get_parent().ui_state = self.get_parent().Ui_state.Dialogue
	Dialogue = self.get_parent().Dialog.instance()
	Dialogue.connect("Dialog_ended",self,"_finish_choosing_dialogue",[pokemon])	
	Dialogue.text_to_diaplay = [pokemon.Name + " I choose you", 0]
	self.get_parent().Dialogue_layer.add_child(Dialogue)
	

func _finish_choosing_dialogue(pokemon):
	self.get_parent()._Dialog_end(self.get_parent().Ui_state.Main)
	PlayerPokemon.current_pokemon = pokemon
	PlayerPokemon.current_pokemon._calc_weak_and_res()
	OpposingTrainerMonsters.pokemon._calc_weak_and_res()
	_kill()

func _input(event):
	if can_select == true:
		if pokemon_selected == false:
			if Input.is_action_pressed("decline"):
				if PlayerPokemon.first_pokemon == null:
					_kill()
				else:
					print("you have to choose a pokemon")
			if Input.is_action_pressed("accept"):
				if current_selected == 1:
					if PlayerPokemon.first_pokemon != null:
						if PlayerPokemon.first_pokemon.fainted == false:
							_say_choosing_dialogue(PlayerPokemon.first_pokemon)	
						else:
							print("Pokemon has no energy to battle")
					else:
						print("no_pokemon_selected")
				elif current_selected == 2:
					if PlayerPokemon.second_pokemon != null:
						if PlayerPokemon.second_pokemon.fainted == false:
							_say_choosing_dialogue(PlayerPokemon.second_pokemon)
						else:
							print("Pokemon has no energy to battle")
					else:
						print("no_pokemon_selected")
				elif current_selected == 3:
					if PlayerPokemon.third_pokemon != null:
						if PlayerPokemon.third_pokemon.fainted == false:
							_say_choosing_dialogue(PlayerPokemon.third_pokemon)
						else:
							print("Pokemon has no energy to battle")
					else:
						print("no_pokemon_selected")
				elif current_selected == 4:
					if PlayerPokemon.fourth_pokemon != null:
						if PlayerPokemon.fourth_pokemon.fainted == false:
							_say_choosing_dialogue(PlayerPokemon.fourth_pokemon)
						else:
							print("Pokemon has no energy to battle")
					else:
						print("no_pokemon_selected")
				elif current_selected == 5:
					if PlayerPokemon.fifth_pokemon != null:
						if PlayerPokemon.fifth_pokemon.fainted == false:
							_say_choosing_dialogue(PlayerPokemon.fifth_pokemon)
						else:
							print("Pokemon has no energy to battle")
					else:
						print("no_pokemon_selected")
				elif current_selected == 6:
					if PlayerPokemon.sixth_pokemon != null:
						if PlayerPokemon.sixth_pokemon.fainted == false:
							_say_choosing_dialogue(PlayerPokemon.sixth_pokemon)
						else:
							print("Pokemon has no energy to battle")
					else:
						print("no_pokemon_selected")
				
			
			if event.is_action_pressed("W"):
				if current_selected == 6:
					current_selected = 1
				else:
					current_selected += 1
			elif event.is_action_pressed("S"):
				if current_selected == 1:
					current_selected = 6
				else:
					current_selected -= 1
			elif event.is_action_pressed("D"):
				if current_selected == 6:
					current_selected = 1
				else:
					current_selected += 1
			elif event.is_action_pressed("A"):
				if current_selected == 1:
					current_selected = 6
				else:
					current_selected -= 1

func _physics_process(_delta):
	if pokemon_selected == false:
		if PlayerPokemon.first_pokemon != null:
			Pokemon_1.texture = PlayerPokemon.first_pokemon.sprite
		else:
			Pokemon_1.texture = null

		if PlayerPokemon.second_pokemon != null:
			Pokemon_2.texture = PlayerPokemon.second_pokemon.sprite
		else:
			Pokemon_2.texture = null
		
		if PlayerPokemon.third_pokemon != null:
			Pokemon_3.texture = PlayerPokemon.third_pokemon.sprite
		else:
			Pokemon_3.texture = null
			
		if PlayerPokemon.fourth_pokemon != null:
			Pokemon_4.texture = PlayerPokemon.fourth_pokemon.sprite
		else:
			Pokemon_4.texture = null
		
		if PlayerPokemon.fifth_pokemon != null:
			Pokemon_5.texture = PlayerPokemon.fifth_pokemon.sprite
		else:
			Pokemon_5.texture = null
			
		if PlayerPokemon.sixth_pokemon != null:
			Pokemon_6.texture = PlayerPokemon.sixth_pokemon.sprite
		else:
			Pokemon_6.texture = null
		
		if current_selected == 1:
			Pokeball_1.texture = SecondarySprite
		else:
			Pokeball_1.texture = main_sprite

		if current_selected == 2:
			Pokeball_2.texture = SecondarySprite
		else:
			Pokeball_2.texture = main_sprite
		if current_selected == 3:
			Pokeball_3.texture = SecondarySprite
		else:
			Pokeball_3.texture = main_sprite
		
		if current_selected == 4:
			Pokeball_4.texture = SecondarySprite
		else:
			Pokeball_4.texture = main_sprite
		
		if current_selected == 5:
			Pokeball_5.texture = SecondarySprite
		else:
			Pokeball_5.texture = main_sprite
		
		if current_selected == 6:
			Pokeball_6.texture = SecondarySprite
		else:
			Pokeball_6.texture = main_sprite
