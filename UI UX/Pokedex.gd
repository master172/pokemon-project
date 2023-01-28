extends Control



var PATH = "res://Game_pokemon/"

var matches = []

const pokedexButton = preload("res://UI UX/PokedexButton.tscn")
 
var text = false

#var id_order = []

#var position_array = []

onready var pokemonContainer = $MainContainer/ScrollContainer/PokemonContainer
onready var ScrollContainer =  $MainContainer/ScrollContainer
onready var items = $MainContainer/ScrollContainer/PokemonContainer.get_children()
onready var pokemonView = $PokemonView
onready var PokemonSprite = $PokemonView/MainContainer/SpriteContainer/TextureRect/Sprite
onready var Name = $PokemonView/MainContainer/TextContainer/Name
onready var Id = $PokemonView/MainContainer/TextContainer/Id
onready var Description = $PokemonView/MainContainer/TextContainer/Description
onready var text_edit = $MainContainer/TextEdit


var ui_state = Ui_state.Active
enum Ui_state {Active,Pokemon}

var current_selected = 0
var max_selected

func _input(event):
	if event.is_action_pressed("decline"):
		if ui_state == Ui_state.Pokemon:
			pokemonView.visible = false 
			text_edit.text = ""
			text_edit.release_focus()
			_on_TextEdit_text_changed("")
			ui_state = Ui_state.Active
		elif ui_state == Ui_state.Active:
			Utils.get_menu()._undisplay_pokedex()
	
	if event.is_action_pressed("S"):
		
		if ui_state == Ui_state.Active:
			max_selected = pokemonContainer.get_child_count()
			if current_selected == max_selected:
				pokemonContainer.get_child(current_selected -1).set("custom_colors/font_color", Color("ffffff"))
				current_selected = 0
			else:
				if current_selected > 0:
					if text_edit.text == "":	
						pokemonContainer.get_child(current_selected -1).set("custom_colors/font_color", Color("ffffff"))
						current_selected += 1
				elif current_selected == 0:
					text_edit.release_focus()
					current_selected += 1
				
			

			if current_selected >= 4:
				ScrollContainer.scroll_vertical += 24
			
			if current_selected == 0:
				ScrollContainer.scroll_vertical = 0
			elif current_selected == max_selected:
				ScrollContainer.scroll_vertical = pokemonContainer.get_child_count() * 24
	
	elif event.is_action_pressed("W"):
		text_edit.release_focus()
		if ui_state == Ui_state.Active:
			max_selected = pokemonContainer.get_child_count()
			if current_selected == 0:
				text_edit.release_focus()
				current_selected = max_selected
			else:
				if current_selected > 0:
					pokemonContainer.get_child(current_selected -1).set("custom_colors/font_color", Color("ffffff"))
				current_selected -= 1

			if current_selected <= max_selected - 4:
				ScrollContainer.scroll_vertical -= 24
			
			if current_selected == 0:
				ScrollContainer.scroll_vertical = 0
			elif current_selected == max_selected:
				ScrollContainer.scroll_vertical = pokemonContainer.get_child_count() * 24
	
	if event.is_action_pressed("accept"):
		if text_edit.text == "":
			if ui_state == Ui_state.Active:
				if current_selected > 0:
					pokemonContainer.get_child(current_selected -1).emit_signal("pressed")
				ui_state = Ui_state.Pokemon
		elif text_edit.text != "":
			if text == false:
				for i in pokemonContainer.get_children():
					if i.visible == false:
						continue
					elif i.visible == true:
						text_edit.text = ""
						i.emit_signal("pressed")
						break

func _ready():
	var pokemons = list_files_in_directory(PATH)
	for i in pokemons:
		var label = pokedexButton.instance()
		var true_name = i.split(".",true,1)
		label.name = true_name[0]
		label.text = true_name[0]
		label.align = 1
		label.connect("pressed",self,"on_button_pressed",[label])
		pokemonContainer.add_child(label)
	
	#for j in pokemonContainer.get_children():
		#var pokemon = load("res://Game_pokemon/"+j.text + ".tscn")
		#var Pokemon = pokemon.instance()
		#id_order.append(Pokemon.id)
	

	
	#sortment_array = id_order

	#create_placement_array()

	
	#for k in range(0,pokemonContainer.get_child_count()- 1):

		#pokemonContainer.move_child(pokemonContainer.get_child(id_order[k]),k)

#func create_placement_array(sortment_array,position_oreder):
	#for i in range(0,sortment_array.size() -1):
		#if sortment_array[i + 1] - sortment_array[i]  == 1:
			#position_oreder.append(i)
		#elif sortment_array[i + 1] -sortment_array[i] > 1:
			#sortment_array[i + 1] = sortment_array[i] + 1
			#position_oreder.append(i)
	

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

	for i in pokemonContainer.get_children():
		i.set("custom_colors/font_color", Color("ffffff"))
	text = true
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

func _physics_process(_delta):
	if current_selected == 0:
		text_edit.grab_focus()
	
	if pokemonView.visible == false:
		ui_state = Ui_state.Active
	elif pokemonView.visible == true:
		ui_state = Ui_state.Pokemon
	if ui_state == Ui_state.Active:
		if text_edit.text == "":
			if current_selected > 0:
				pokemonContainer.get_child(current_selected -1).set("custom_colors/font_color", Color("00c3ff"))

			for i in pokemonContainer.get_children():
				if i.visible == false:
					continue
				elif i.visible == true:
					i.set("custom_colors/font_color", Color("00c3ff"))
					break

func _on_TextEdit_text_entered(new_text:String):
	text = false
	text_edit.release_focus()

