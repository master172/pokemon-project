extends Node

const SAVE_DIR = "user://Saves/Pokemon_data/Moves/"
const SAVE_PATH = SAVE_DIR +"Moves.json"
var _settings = {}


func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	load_game()


func save_game():
	# Get all the save data from persistent nodes
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group("presistent")
	for nodes in nodes_to_save:
		if nodes.has_method("_check_to_add"):
			nodes._check_to_add()
		save_dict[nodes.get_path()] = nodes.save()
		pass
	# Create a file

	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)
	# Serialize the data dictionary to JSON
	save_file.store_line(to_json(save_dict))
	# Write the JSON to the file and save to disk
	save_file.close()

func load_game():
	# Try to load a saved file
	var save_file = File.new()

	if not save_file.file_exists(SAVE_PATH):
		return
	# Parse the file data if it exists
	save_file.open(SAVE_PATH, File.READ)
	var data = {}
	data = JSON.parse(save_file.get_as_text()).result
	# load the data into persistent nodes
	for node_path in data.keys():
		var node = get_node(node_path)

		for attribute in data[node_path]:
			if attribute == "pos":
				node.set_pos(Vector2(data[node_path]['pos_x']['x'],data[node_path]['pos_y']['y']))
			else:
				node.set(attribute,data[node_path][attribute])
	
	save_file.close()


