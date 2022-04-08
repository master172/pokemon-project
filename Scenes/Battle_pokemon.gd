extends Node2D

var controller

enum states {Main , Poke_cont_box}
var State = states.Main

var Poke_cont_box

const poke_cont_box = preload("res://Ui/Battle_box_cont.tscn")
var current_selected:int = 1

func _kill():
	yield(get_tree().create_timer(0.1),"timeout")
	self.controller.ui_state = self.controller.Ui_state.Main
	queue_free()

func _input(event):
	if controller != null:
		if event.is_action_pressed("accept") and State == states.Main:
			Poke_cont_box = poke_cont_box.instance()
			self.add_child(Poke_cont_box)
			Poke_cont_box.controller = self
			State = states.Poke_cont_box
			if current_selected == 1:
				Poke_cont_box.Pokemon_cont = PlayerPokemon.first_pokemon
			if current_selected == 2:
				Poke_cont_box.Pokemon_cont = PlayerPokemon.second_pokemon
			if current_selected == 3:
				Poke_cont_box.Pokemon_cont = PlayerPokemon.third_pokemon
			if current_selected == 4:
				Poke_cont_box.Pokemon_cont = PlayerPokemon.fourth_pokemon
			if current_selected == 5:
				Poke_cont_box.Pokemon_cont = PlayerPokemon.fifth_pokemon
			if current_selected == 6:
				Poke_cont_box.Pokemon_cont = PlayerPokemon.sixth_pokemon
		elif event.is_action_pressed("decline") and State == states.Poke_cont_box:
			if is_instance_valid(Poke_cont_box):
				Poke_cont_box.queue_free()
				State = states.Main
		if is_instance_valid(Poke_cont_box):
			State = states.Poke_cont_box
		else:
			State = states.Main
		if State == states.Main:
			if event.is_action_pressed("A"):
				if current_selected == 1:
					current_selected = 6
				elif current_selected == 2:
					current_selected = 4
				elif current_selected == 3:
					current_selected = 5
				elif current_selected == 4:
					current_selected = 1
				elif current_selected == 5:
					current_selected = 2
				elif current_selected == 6:
					current_selected = 3

			elif event.is_action_pressed("D"):
				if current_selected == 1:
					current_selected = 4
				elif current_selected == 2:
					current_selected = 5
				elif current_selected == 3:
					current_selected = 6
				elif current_selected == 4:
					current_selected = 2
				elif current_selected == 5:
					current_selected = 3
				elif current_selected == 6:
					current_selected = 1

			if event.is_action_pressed("W"):
				if current_selected == 1:
					current_selected = 6
				else:
					current_selected = current_selected - 1
			elif event.is_action_pressed("S"):
				if current_selected == 6:
					current_selected = 1
				else:
					current_selected = current_selected + 1


func _physics_process(delta):
	if current_selected == 1:
		$Control/Pokemons/Pokemon1/Battle_selector.frame = 1
	else:
		$Control/Pokemons/Pokemon1/Battle_selector.frame = 0

	if current_selected == 2:
		$Control/Pokemons/Pokemon2/Battle_selector.frame = 1
	else:
		$Control/Pokemons/Pokemon2/Battle_selector.frame = 0

	if current_selected == 3:
		$Control/Pokemons/Pokemon3/Battle_selector.frame = 1
	else:
		$Control/Pokemons/Pokemon3/Battle_selector.frame = 0

	if current_selected == 4:
		$Control/Pokemons/Pokemon4/Battle_selector.frame = 1
	else:
		$Control/Pokemons/Pokemon4/Battle_selector.frame = 0

	if current_selected == 5:
		$Control/Pokemons/Pokemon5/Battle_selector.frame = 1
	else:
		$Control/Pokemons/Pokemon5/Battle_selector.frame = 0

	if current_selected == 6:
		$Control/Pokemons/Pokemon6/Battle_selector.frame = 1
	else:
		$Control/Pokemons/Pokemon6/Battle_selector.frame = 0
		
	if PlayerPokemon.first_pokemon != null:
		$Control/Pokemons/Pokemon1/Pokemon_Sprite.texture = PlayerPokemon.first_pokemon.sprite
		$Control/Pokemons/Pokemon1/Pokemon_name.texture = PlayerPokemon.first_pokemon.sprite
		$Control/Pokemons/Pokemon1/Pokemon_footprint.texture = PlayerPokemon.first_pokemon.sprite
	else:
		$Control/Pokemons/Pokemon1/Pokemon_Sprite.texture = null
		$Control/Pokemons/Pokemon1/Pokemon_name.texture = null
		$Control/Pokemons/Pokemon1/Pokemon_footprint.texture = null

	if PlayerPokemon.second_pokemon != null:
		$Control/Pokemons/Pokemon2/Pokemon_Sprite.texture = PlayerPokemon.second_pokemon.sprite
		$Control/Pokemons/Pokemon2/Pokemon_name.texture = PlayerPokemon.second_pokemon.sprite
		$Control/Pokemons/Pokemon2/Pokemon_footprint.texture = PlayerPokemon.second_pokemon.sprite
	else:
		$Control/Pokemons/Pokemon2/Pokemon_Sprite.texture = null
		$Control/Pokemons/Pokemon2/Pokemon_name.texture = null
		$Control/Pokemons/Pokemon2/Pokemon_footprint.texture = null

	if PlayerPokemon.third_pokemon != null:
		$Control/Pokemons/Pokemon3/Pokemon_Sprite.texture = PlayerPokemon.third_pokemon.sprite
		$Control/Pokemons/Pokemon3/Pokemon_name.texture = PlayerPokemon.third_pokemon.sprite
		$Control/Pokemons/Pokemon3/Pokemon_footprint.texture = PlayerPokemon.third_pokemon.sprite
	else:
		$Control/Pokemons/Pokemon3/Pokemon_Sprite.texture = null
		$Control/Pokemons/Pokemon3/Pokemon_name.texture = null
		$Control/Pokemons/Pokemon3/Pokemon_footprint.texture = null

	if PlayerPokemon.fourth_pokemon != null:
		$Control/Pokemons/Pokemon4/Pokemon_Sprite.texture = PlayerPokemon.fourth_pokemon.sprite
		$Control/Pokemons/Pokemon4/Pokemon_name.texture = PlayerPokemon.fourth_pokemon.sprite
		$Control/Pokemons/Pokemon4/Pokemon_footprint.texture = PlayerPokemon.fourth_pokemon.sprite
	else:
		$Control/Pokemons/Pokemon4/Pokemon_Sprite.texture = null
		$Control/Pokemons/Pokemon4/Pokemon_name.texture = null
		$Control/Pokemons/Pokemon4/Pokemon_footprint.texture = null

	if PlayerPokemon.fifth_pokemon != null:
		$Control/Pokemons/Pokemon5/Pokemon_Sprite.texture = PlayerPokemon.fifth_pokemon.sprite
		$Control/Pokemons/Pokemon5/Pokemon_name.texture = PlayerPokemon.fifth_pokemon.sprite
		$Control/Pokemons/Pokemon5/Pokemon_footprint.texture = PlayerPokemon.fifth_pokemon.sprite
	else:
		$Control/Pokemons/Pokemon5/Pokemon_Sprite.texture = null
		$Control/Pokemons/Pokemon5/Pokemon_name.texture = null
		$Control/Pokemons/Pokemon5/Pokemon_footprint.texture = null

	if PlayerPokemon.sixth_pokemon != null:
		$Control/Pokemons/Pokemon6/Pokemon_Sprite.texture = PlayerPokemon.sixth_pokemon.sprite
		$Control/Pokemons/Pokemon6/Pokemon_name.texture = PlayerPokemon.sixth_pokemon.sprite
		$Control/Pokemons/Pokemon6/Pokemon_footprint.texture = PlayerPokemon.sixth_pokemon.sprite
	else:
		$Control/Pokemons/Pokemon6/Pokemon_Sprite.texture = null
		$Control/Pokemons/Pokemon6/Pokemon_name.texture = null
		$Control/Pokemons/Pokemon6/Pokemon_footprint.texture = null
	
	

		
