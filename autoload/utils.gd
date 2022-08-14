extends Node

var current_rest_shelter

const SAVE_DIR = "user://Saves/Utilities/"
const save_path = SAVE_DIR + "Utils_save.json"

var Utils_data

var parent_to_change

var Num_loaded_pokemon : int = 0

func get_player():
	return get_node("/root/SceneManager/CurrentScene").get_children().back().find_node("ash")

func Get_Scene_Manager():
	return get_node("/root/SceneManager")

func Get_Pokemon_Manger():
	return get_node("/root/SceneManager/Pokemon_scene")

func get_dialog_layer():
	return get_node("/root/SceneManager/Dialog")

func _save_data():
	#the data needed to be saved
	var data = {
		"Num_loaded_pokemon":Num_loaded_pokemon,
		"current_rest_shelter": current_rest_shelter,
	}

	#creating the file and saving the data

	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
		
	var file = File.new()
	var error = file.open(save_path,File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()

#loading the player_data
func _load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path,File.READ)
		if error == OK:
			Utils_data = file.get_var()
			file.close()

			_apply_data()

#calling  the save function while close the game
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_save_data()

#applying the saved data to the player
func _apply_data():
	if Utils_data != null:
		self.Num_loaded_pokemon = Utils_data.Num_loaded_pokemon
