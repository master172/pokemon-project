extends Node2D

onready var Dialogue_layer = $DialogLayer

onready var base_sprite = $Pokemon_base
onready var evolution_sprite = $Pokemon_evoluter

onready var animator = $AnimationPlayer

onready var Background = $Background

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

var Evolution_Pokemon

signal evolution_done

func _ready():
	base_sprite.visible = false
	evolution_sprite.visible = false
	Background.visible = false
	self.visible = false

func start_evolutuon(pokemon,Base_sprite,Evolver_Sprite):
	Evolution_Pokemon = pokemon
	base_sprite.texture = Base_sprite
	evolution_sprite.texture = Evolver_Sprite
	base_sprite.visible = true
	evolution_sprite.visible = true
	Background.visible = true
	self.visible = true
	InitEvolutionDialog(pokemon)

func InitEvolutionDialog(evolution_Pokemon):
	var Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = ["What!",evolution_Pokemon.Name + " is evolving ","do you want your pokemon to evolve",1, 0]
	Dialogue.choices = [["yes",evolution_Pokemon.Name +" is gonna evolve",1],["no",evolution_Pokemon.Name + " didn't evolve" ,1]]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("_choice_number",self,"make_decision")

func make_decision(choice):
	if choice == 0:
		EvolutionProcess()
	elif choice == 1:
		print("make arrangement")
		MakeArrangement()

func EvolutionProcess():
	yield(get_tree().create_timer(0.2),"timeout")
	animator.play("evolve")
	Evolution_Pokemon.evolution_value_change()

func EvolutionDone():
	var Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = ["congratulations yur pokemon evolved", 0]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("Dialog_ended",self,"MakeArrangement")

func MakeArrangement():
	yield(get_tree().create_timer(0.2),"timeout")
	base_sprite.visible = false
	evolution_sprite.visible = false
	Background.visible = false
	animator.play("Fade_out")
	

func FinishEvolution():
	Background.visible = false
	self.visible = false
	emit_signal("evolution_done")