extends Node

var current_rest_shelter

const SAVE_DIR = "user://Saves/Utilities/"
const save_path = SAVE_DIR + "Utils_save.json"

var Utils_data

var parent_to_change

var Num_loaded_pokemon : int = 0

var pc_state = null
var pc_num = null

var pc

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
		file.store_line(to_json(data))
		file.close()

#loading the player_data
func _load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path,File.READ)
		if error == OK:
			Utils_data = JSON.parse(file.get_as_text()).result
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
		self.current_rest_shelter = Utils_data.current_rest_shelter

func _set_pc_reload_data(state,num):
	
	pc_state = state
	pc_num = num
	print_debug("data_set data: ", pc_state, " ", pc_num)

func make_pc_connection():
	pc.connect("instantated",self,"_make_reload_provisions")


func destroy_pc_connection():
	pc.disconnect("instantated",self,"_make_reload_provisions")
	pc = null

func _make_reload_provisions():
	print_debug("reloading")
	if pc_state and pc_num != null:
		print_debug("setting_data")
		pc.state = pc_state
		if pc_state == 6:
			pc.Toggle_control.color = Color("0b042a")
			pc.Toggle_definer.color = Color("00ffffff")
			pc.Pokemon_control.color = Color("b8ff00b9")
			pc.Pokemon_definer.color  = Color("ff00b9")
		pc.current_selected = pc_num
		pc_state = null
		pc_num = null
