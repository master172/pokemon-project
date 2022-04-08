extends Node2D

enum Options { FIRST_SLOT, SECOND_SLOT, THIRD_SLOT, FOURTH_SLOT, FIFTH_SLOT, SIXTH_SLOT, CANCEL }
var selected_option: int = Options.FIRST_SLOT

enum Pokemon {Pokemon_1, Pokemon_2, Pokemon_3, Pokemon_4, Pokemon_5,Pokemon_6}

var option_to_go

const poke_cont_box = preload("res://Ui/Poke_cont_box.tscn")

var Poke_cont_box

var cont

var playable : bool = true

var first_pokemon 

var first_slot
var second_slot

var switching:bool

var p1:bool = false
var p2:bool = false
var p3:bool = false
var p4:bool = false
var p5:bool = false
var p6:bool = false


onready var options: Dictionary = {
	Options.FIRST_SLOT: $Pokemon_1/Back_ground,
	Options.SECOND_SLOT: $Pokemon_2/Back_ground,
	Options.THIRD_SLOT: $Pokemon_3/Back_ground,
	Options.FOURTH_SLOT: $Pokemon_4/Back_ground,
	Options.FIFTH_SLOT: $Pokemon_5/Back_ground,
	Options.SIXTH_SLOT: $Pokemon_6/Back_ground,
	Options.CANCEL: $Cancel_sprite,
}


onready var pokemon : Dictionary = {
	Pokemon.Pokemon_1: $Pokemon_1,
	Pokemon.Pokemon_2: $Pokemon_2,
	Pokemon.Pokemon_3: $Pokemon_3,
	Pokemon.Pokemon_4: $Pokemon_4,
	Pokemon.Pokemon_5: $Pokemon_5,
	Pokemon.Pokemon_6: $Pokemon_6
}
func unset_active_option():
	if options[selected_option] != first_pokemon:
		options[selected_option].frame = 0
	elif options[selected_option] == first_pokemon:
		options[selected_option].frame = 1
	
func set_active_option():
	options[selected_option].frame = 1
	

func _ready():
	$Pokemon_1.visible = false
	$Pokemon_2.visible = false
	$Pokemon_3.visible = false
	$Pokemon_4.visible = false
	$Pokemon_5.visible = false
	$Pokemon_6.visible = false
	set_active_option()

func _physics_process(_delta):

		
	if PlayerPokemon.first_pokemon != null:
		$Pokemon_1.visible = true
		$Pokemon_1/Pokemon_sprite.texture = PlayerPokemon.first_pokemon.sprite
		$Pokemon_1/Level.text = String(PlayerPokemon.first_pokemon.level)
		p1 = true
	if PlayerPokemon.second_pokemon != null:
		$Pokemon_2.visible = true
		$Pokemon_2/Pokemon_sprite.texture = PlayerPokemon.second_pokemon.sprite
		$Pokemon_2/Level.text = String(PlayerPokemon.second_pokemon.level)
		p2 = true
	if PlayerPokemon.third_pokemon != null:
		$Pokemon_3.visible = true
		$Pokemon_3/Pokemon_sprite.texture = PlayerPokemon.third_pokemon.sprite
		$Pokemon_3/Level.text = String(PlayerPokemon.third_pokemon.level)
		p3 = true
	if PlayerPokemon.fourth_pokemon != null:
		$Pokemon_4.visible = true
		$Pokemon_4/Pokemon_sprite.texture = PlayerPokemon.fourth_pokemon.sprite
		$Pokemon_4/Level.text = String(PlayerPokemon.fourth_pokemon.level)
		p4 = true
	if PlayerPokemon.fifth_pokemon != null:
		$Pokemon_5.visible = true
		$Pokemon_5/Pokemon_sprite.texture = PlayerPokemon.fifth_pokemon.sprite
		$Pokemon_5/Level.text = String(PlayerPokemon.fifth_pokemon.level)
		p5 = true
	if PlayerPokemon.sixth_pokemon != null:
		$Pokemon_6.visible = true
		$Pokemon_6/Pokemon_sprite.texture = PlayerPokemon.sixth_pokemon.sprite
		$Pokemon_6/Level.text = String(PlayerPokemon.sixth_pokemon.level)
		p6 = true



func _input(event):
	if playable == true:
		if event.is_action_pressed("S"):
			unset_active_option()
			if selected_option == Options.FIRST_SLOT:
				if p2 == false:
					option_to_go = 6
				elif p2 == true:
					option_to_go = 1
			elif selected_option == Options.SECOND_SLOT:
				if p3 == false:
					option_to_go = 5
				elif p3 == true:
					option_to_go = 1
			elif selected_option == Options.THIRD_SLOT:
				if p4 == false:
					option_to_go = 4
				elif p4 == true:
					option_to_go = 1
			elif selected_option == Options.FOURTH_SLOT:
				if p5 == false:
					option_to_go = 3
				elif p5 == true:
					option_to_go = 1
			elif selected_option == Options.FIFTH_SLOT:
				if p6 == false:
					option_to_go = 2
				elif p6 == true:
					option_to_go = 1
			elif selected_option == Options.CANCEL:
				if p1 == false:
					selected_option = Options.CANCEL
				elif p1 == true:
					selected_option = Options.FIRST_SLOT
			
			selected_option = (selected_option + option_to_go) % 7
			set_active_option()
		elif event.is_action_pressed("W"):
			unset_active_option()
			if selected_option == 0:
				selected_option = Options.CANCEL
			if selected_option == Options.CANCEL and p6 == false: 
				option_to_go = 2
			if selected_option == Options.CANCEL and p5 == false:
				option_to_go = 3
			if selected_option == Options.CANCEL and p4 == false:
				option_to_go = 4
			if selected_option == Options.CANCEL and p3 == false:
				option_to_go = 5
			if selected_option == Options.CANCEL and p2 == false:
				option_to_go = 6
			if selected_option == Options.CANCEL and p1 == false:
				option_to_go = 7
			if selected_option == Options.CANCEL and p6 == true:
				option_to_go = 1
			if selected_option != Options.CANCEL:
				option_to_go = 1
			selected_option -= option_to_go
			set_active_option()
		elif event.is_action_pressed("A"):
			unset_active_option()
			selected_option = 0
			set_active_option()
		elif event.is_action_pressed("D") and selected_option == Options.FIRST_SLOT and p1 == true:
			unset_active_option()
			selected_option = 1
			set_active_option()
		elif event.is_action_pressed("accept"):
			match selected_option:
				Options.CANCEL:
					Utils.Get_Scene_Manager().transition_exit_party_scene()
				Options.FIRST_SLOT:
					if first_slot== null:
						first_slot= PlayerPokemon.first_pokemon
					elif first_slot!= null and first_slot!= PlayerPokemon.first_pokemon and second_slot == null:
						second_slot = PlayerPokemon.first_pokemon
						switch()
					if switching == false:
						poke_cont_start()
				Options.SECOND_SLOT:
					if first_slot== null:
						first_slot= PlayerPokemon.second_pokemon
					elif first_slot!= null and first_slot!= PlayerPokemon.second_pokemon and second_slot == null:
						second_slot = PlayerPokemon.second_pokemon
						switch()
					if switching == false:
						poke_cont_start()
				Options.THIRD_SLOT:
					if first_slot== null:
						first_slot= PlayerPokemon.third_pokemon
					elif first_slot!= null and first_slot!= PlayerPokemon.third_pokemon and second_slot == null:
						second_slot = PlayerPokemon.third_pokemon
						switch()
					if switching == false:
						poke_cont_start()
				Options.FOURTH_SLOT:
					if first_slot== null:
						first_slot= PlayerPokemon.fourth_pokemon
					elif first_slot!= null and first_slot!= PlayerPokemon.fourth_pokemon and second_slot == null:
						second_slot = PlayerPokemon.fourth_pokemon
						switch()
					if switching == false:
						poke_cont_start()
				Options.FIFTH_SLOT:
					if first_slot== null:
						first_slot= PlayerPokemon.fifth_pokemon
					elif first_slot!= null and first_slot!= PlayerPokemon.fifth_pokemon and second_slot == null:
						second_slot = PlayerPokemon.fifth_pokemon
						switch()
					if switching == false:
						poke_cont_start()
				Options.SIXTH_SLOT:
					if first_slot== null:
						first_slot= PlayerPokemon.sixth_pokemon
					elif first_slot!= null and first_slot!= PlayerPokemon.sixth_pokemon and second_slot == null:
						second_slot = PlayerPokemon.sixth_pokemon
						switch()
					if switching == false:
						poke_cont_start()

func pre_switch():
	cont._kill()
	yield(get_tree().create_timer(.2), "timeout")
	first_pokemon = options[selected_option]
	playable = true
	yield(get_tree().create_timer(.1), "timeout")
	first_pokemon.frame = 1
	switching = true

func switch():
	PlayerPokemon.switch(first_slot,second_slot)
	yield(get_tree().create_timer(.2), "timeout")
	end_switch()

func end_switch():
	first_pokemon.frame = 0
	first_slot = null
	second_slot = null
	yield(get_tree().create_timer(.2), "timeout")
	switching = false

func poke_cont_start():
	Poke_cont_box = poke_cont_box.instance()
	playable = false
	Poke_cont_box.controller = self
	self.add_child(Poke_cont_box)
	cont = Poke_cont_box

func poke_cont_end():
	first_slot = null
	second_slot = null
	cont._kill()
	yield(get_tree().create_timer(.2), "timeout")
	playable = true
