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

func _ready():
	yield(get_tree().create_timer(2),"timeout")
	pokemon1 = first_pokemon
	pokemon2 = second_pokemon
	pokemon3 = third_pokemon
	pokemon4 = fourth_pokemon
	pokemon5 = fifth_pokemon
	pokemon6 = sixth_pokemon


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
		if Input.is_action_just_pressed("test"):
			current_pokemon.experince_gained += 1000
			current_pokemon._update_level()

