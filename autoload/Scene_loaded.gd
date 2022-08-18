extends Node

const SAVE_DIR = "user://Saves/Scene/"
const save_path = SAVE_DIR +"scene.json"
var current_scene

func _ready():
	_load_data()

func _save_data():
	var data = current_scene

	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open(save_path,File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()

func _load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path,File.READ)
		if error == OK:
			current_scene = file.get_var()
			file.close()

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_save_data()

