extends Node2D

var Max_location = -130
var Min_location = 274

var current = false
var num = 1

onready var anim_player = $AnimationPlayer
onready var Main_label = $Control/Main_Label
onready var Description_label = $Control/Description_box

func _ready():
	if PlayerPokemon.current_pokemon != null:
		if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3:
			Main_label.text = PlayerPokemon.current_pokemon.Learned_moves[2].name
			Description_label.text = PlayerPokemon.current_pokemon.Learned_moves[2].description
		else:
			Main_label.text = " "
			Description_label.text = " "
	else:
		Main_label.text = " "
		Description_label.text = " "


func _physics_process(_delta):
	if PlayerPokemon.current_pokemon != null:
		if PlayerPokemon.current_pokemon.Learned_moves.size() >= 3:
			Main_label.text = PlayerPokemon.current_pokemon.Learned_moves[2].name
			Description_label.text = PlayerPokemon.current_pokemon.Learned_moves[2].description
		else:
			Main_label.text = " "
			Description_label.text = " "
	else:
		Main_label.text = " "
		Description_label.text = " "
	if self.position.x == 72:
		anim_player.play("Default")
	else:
		anim_player.play("Side_stepped")
	if self.position.x < Max_location:
		self.position.x = Min_location
	if self.position.x > Min_location:
		self.position.x = Max_location