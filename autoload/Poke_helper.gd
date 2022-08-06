extends Node


var weathers : Array  = ["Sunny","Clear","Rainy"]

var current_weather = weathers[1]

var player_badjes :int = 0

var save_path = "user://Inventory.txt"

var Inventory_data
var Pokeballs = []
var Key_items = []
var Tm_Hm = []
var Berries = []
var Free_space = []
var Battle_Items = []
var Medicine = []
var items = []

func _ready():
	_load_data()

func _save_data():
	#the data needed to be saved
	var data = {
		"items":items,
		"Pokeballs":Pokeballs,
		"Key_items":Key_items,
		"Tm_Hm":Tm_Hm,
		"Berries":Berries,
		"Free_space":Free_space,
		"Battle_Items":Battle_Items,
		"Medicine":Medicine,
	}

	#creating the file and saving the data
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
			Inventory_data = file.get_var()
			file.close()
			_apply_data()

#calling  the save function while close the game
func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_save_data()

#applying the saved data to the player
func _apply_data():
	if Inventory_data != null:
		self.items = Inventory_data.items
		self.Pokeballs = Inventory_data.Pokeballs
		self.Key_items = Inventory_data.Key_items
		self.Tm_Hm = Inventory_data.Tm_Hm
		self.Berries = Inventory_data.Berries
		self.Free_space = Inventory_data.Free_space
		self.Battle_Items = Inventory_data.Battle_Items
		self.Medicine = Inventory_data.Medicine
		Inventory_data = null

