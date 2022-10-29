extends Control

onready var pokemonContainer = $MainContainer/ScrollContainer/PokemonContainer

var PATH = "res://Game_pokemon/"

var matches = []

onready var items = $MainContainer/ScrollContainer/PokemonContainer.get_children()
onready var pokemonView = $PokemonView
onready var PokemonSprite = $PokemonView/MainContainer/SpriteContainer/TextureRect/Sprite
onready var Name = $PokemonView/MainContainer/TextContainer/Name
onready var Id = $PokemonView/MainContainer/TextContainer/Id
onready var Description = $PokemonView/MainContainer/TextContainer/Description

func _input(event):
	if event.is_action_pressed("decline") and pokemonView.visible == true:
		pokemonView.visible = false 

func _ready():
	var pokemons = list_files_in_directory(PATH)
	for i in pokemons:
		var label = Button.new()
		var true_name = i.split(".",true,1)
		label.name = true_name[0]
		label.text = true_name[0]
		label.align = 1
		label.connect("pressed",self,"on_button_pressed",[label])
		pokemonContainer.add_child(label)

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func _on_TextEdit_text_changed(new_text:String):
	items = $MainContainer/ScrollContainer/PokemonContainer.get_children()
	new_text = new_text.to_lower()
	if new_text == "":
		for i in items:
			i.show()
		return
	matches.clear()
	for i in items:
		if new_text in i.text.to_lower():
			matches.append(i)
	for i in items:
		if i in matches:
			i.show()
		else:
			i.hide()


func on_button_pressed(button):
	var pokemon = load("res://Game_pokemon/"+button.name + ".tscn")
	var Pokemon = pokemon.instance()
	PokemonSprite.texture = Pokemon.sprite
	Name.text = "Pokemon name: "+Pokemon.Name
	Id.text = "Pokemon ID: "+String(Pokemon.id)
	Description.text = Pokemon.pokemon_entry
	pokemonView.visible = true
