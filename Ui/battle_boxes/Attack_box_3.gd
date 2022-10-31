extends Node2D

var Max_location = -130
var Min_location = 274

var current = false
var num = 1

onready var anim_player = $AnimationPlayer
onready var Main_label = $Control/Main_Label
onready var Type_image = $Control/TextureRect
onready var Effect_image = $EffectivenessBox

func _ready():
	if PlayerPokemon.current_pokemon != null:
		if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3:
			Effect_image.visible = true
			Main_label.text = PlayerPokemon.current_pokemon.Learned_moves[2].name
			Type_image.texture = PlayerPokemon.current_pokemon.Learned_moves[2].type_image
			if PlayerPokemon.current_pokemon.Learned_moves[2].effectiveness == 1:
				Effect_image.frame = 2
			elif PlayerPokemon.current_pokemon.Learned_moves[2].effectiveness == 0.5:
				Effect_image.frame = 1
			elif PlayerPokemon.current_pokemon.Learned_moves[2].effectiveness == 2:
				Effect_image.frame = 3
		else:
			Main_label.text = " "
			Type_image.texture = null
			Effect_image.visible = false
	else:
		Main_label.text = " "
		Type_image.texture = null
		Effect_image.visible = false


func _physics_process(_delta):
	if PlayerPokemon.current_pokemon != null:
		if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3:
			Effect_image.visible = true
			Main_label.text = PlayerPokemon.current_pokemon.Learned_moves[2].name
			Type_image.texture = PlayerPokemon.current_pokemon.Learned_moves[2].type_image
			if PlayerPokemon.current_pokemon.Learned_moves[2].effectiveness == 1:
				Effect_image.frame = 2
			elif PlayerPokemon.current_pokemon.Learned_moves[2].effectiveness == 0.5:
				Effect_image.frame = 1
			elif PlayerPokemon.current_pokemon.Learned_moves[2].effectiveness == 2:
				Effect_image.frame = 3
		else:
			Main_label.text = " "
			Type_image.texture = null
			Effect_image.visible = false
	else:
		Main_label.text = " "
		Type_image.texture = null
		Effect_image.visible = false

	if self.position.x == 72:
		anim_player.play("Default")
	else:
		anim_player.play("Side_stepped")
	if self.position.x < Max_location:
		self.position.x = Min_location
	if self.position.x > Min_location:
		self.position.x = Max_location