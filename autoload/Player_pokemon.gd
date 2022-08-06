extends Node2D

var lost = false
var won = false

var first_pokemon_fainted = false
var second_pokemon_fainted = false
var third_pokemon_fainted = false
var fourth_pokemon_fainted = false
var fifth_pokemon_fainted = false
var sixth_pokemon_fainted = false

var pokemon1 
var pokemon2 
var pokemon3 
var pokemon4 
var pokemon5 
var pokemon6 

var targets : int = 1

var current_pokemon

var opposing_pokemon

var first_pokemon
var second_pokemon
var third_pokemon
var fourth_pokemon
var fifth_pokemon
var sixth_pokemon

var pc_pokemon : Array

	
func _check_evolution():
	if self.first_pokemon != null:
		self.first_pokemon.evolve()
	if self.second_pokemon != null:
		self.second_pokemon.evolve()
	if self.third_pokemon != null:
		self.third_pokemon.evolve()
	if self.fourth_pokemon != null:
		self.fourth_pokemon.evolve()
	if self.fifth_pokemon != null:
		self.fifth_pokemon.evolve()
	if self.sixth_pokemon != null:
		self.sixth_pokemon.evolve()



func _ready():
	yield(get_tree().create_timer(2),"timeout")
	pokemon1 = first_pokemon
	pokemon2 = second_pokemon
	pokemon3 = third_pokemon
	pokemon4 = fourth_pokemon
	pokemon5 = fifth_pokemon
	pokemon6 = sixth_pokemon

func _switch(selected_pokemon_1,selected_pokemon_2):
	var tmp = selected_pokemon_1.change_path
	var tmp_1 = selected_pokemon_1.change_pc_poke

	

	selected_pokemon_1.change_path = selected_pokemon_2.change_path
	selected_pokemon_1.change_pc_poke = selected_pokemon_2.change_pc_poke

	selected_pokemon_2.change_path = tmp
	selected_pokemon_2.change_pc_poke = tmp_1

	if pc_pokemon.has(selected_pokemon_2):
		pc_pokemon.erase(selected_pokemon_2)
		pc_pokemon.append(selected_pokemon_1)

	if selected_pokemon_2.change_path == "first_pokemon":
		first_pokemon = selected_pokemon_2
	elif selected_pokemon_2.change_path == "second_pokemon":
		second_pokemon = selected_pokemon_2
	elif selected_pokemon_2.change_path == "third_pokemon":
		third_pokemon = selected_pokemon_2
	elif selected_pokemon_2.change_path == "fourth_pokemon":
		fourth_pokemon = selected_pokemon_2
	elif selected_pokemon_2.change_path == "fifth_pokemon":
		fifth_pokemon = selected_pokemon_2
	elif selected_pokemon_2.change_path == "sixth_pokemon":
		sixth_pokemon = selected_pokemon_2
	



	



func switch(first_slot, second_slot):
	var tmp = first_slot
	first_slot = second_slot
	second_slot = tmp
	yield(get_tree().create_timer(.2),"timeout")
	
	if first_pokemon == first_slot:
		first_pokemon = second_slot
		first_pokemon.change_path = "first_pokemon"
	elif first_pokemon == second_slot:
		first_pokemon = first_slot
		first_pokemon.change_path = "first_pokemon"
	
	if second_pokemon == first_slot:
		second_pokemon = second_slot
		second_pokemon.change_path = "second_pokemon"
	elif second_pokemon == second_slot:
		second_pokemon = first_slot
		second_pokemon.change_path = "second_pokemon"
	
	if third_pokemon == first_slot:
		third_pokemon = second_slot
		third_pokemon.change_path = "third_pokemon"
	elif third_pokemon == second_slot:
		third_pokemon = first_slot
		third_pokemon.change_path = "third_pokemon"
	
	if fourth_pokemon == first_slot:
		fourth_pokemon = second_slot
		fourth_pokemon.change_path = "fourth_pokemon"
	elif fourth_pokemon == second_slot:
		fourth_pokemon = first_slot
		fourth_pokemon.change_path = "fourth_pokemon"

	if fifth_pokemon == first_slot:
		fifth_pokemon = second_slot
		fifth_pokemon.change_path = "fifth_pokemon"
	elif fifth_pokemon == second_slot:
		fifth_pokemon = first_slot
		fifth_pokemon.change_path = "fifth_pokemon"
	
	if sixth_pokemon == first_slot:
		sixth_pokemon = second_slot
		sixth_pokemon.change_path = "sixth_pokemon"
	elif sixth_pokemon == second_slot:
		sixth_pokemon = first_slot
		sixth_pokemon.change_path = "sixth_pokemon"
	return


func _physics_process(_delta):
	
	if current_pokemon != null:
		if current_pokemon.opposing_pokemon == null and OpposingTrainerMonsters.pokemon != null:
			current_pokemon.opposing_pokemon = OpposingTrainerMonsters.pokemon
		if Input.is_action_just_pressed("test"):
			current_pokemon.experince_gained += 1000
			current_pokemon._update_level()

