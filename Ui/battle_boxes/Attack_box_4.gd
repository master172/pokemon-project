extends Node2D

var Max_location = -130
var Min_location = 274

var current = false
var num = 2

onready var anim_player = $AnimationPlayer
onready var Main_label = $Control/Main_Label
onready var Description_label = $Control/Description_box
onready var Type_image = $Control/TextureRect

func _ready():
	if PlayerPokemon.current_pokemon != null:
		if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4:
			Main_label.text = PlayerPokemon.current_pokemon.Learned_moves[3].name
			Description_label.text = PlayerPokemon.current_pokemon.Learned_moves[3].description
			Type_image.texture = PlayerPokemon.current_pokemon.Learned_moves[3].type_image
		else:
			Main_label.text = " "
			Description_label.text = " "
			Type_image.texture = null
	else:
		Main_label.text = " "
		Description_label.text = " "
		Type_image.texture = null


func _physics_process(_delta):
	if PlayerPokemon.current_pokemon != null:
		if PlayerPokemon.current_pokemon.Learned_moves.size() >= 4:
			Main_label.text = PlayerPokemon.current_pokemon.Learned_moves[3].name
			Description_label.text = PlayerPokemon.current_pokemon.Learned_moves[3].description
			Type_image.texture = PlayerPokemon.current_pokemon.Learned_moves[3].type_image
		else:
			Main_label.text = " "
			Description_label.text = " "
			Type_image.texture = null
	else:
		Main_label.text = " "
		Description_label.text = " "
		Type_image.texture = null
	if self.position.x == 72:
		anim_player.play("Default")
	else:
		anim_player.play("Side_stepped")
	if self.position.x < Max_location:
		self.position.x = Min_location
	if self.position.x > Min_location:
		self.position.x = Max_location
