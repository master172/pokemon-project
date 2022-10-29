extends Control

onready var tabContainer = $TabContainer
onready var GeneralOptionContainer = $TabContainer/General/ScrollContainer/GeneralOptionContainer

onready var BaseContainer = $TabContainer/General/ScrollContainer/GeneralOptionContainer/BaseContainer
onready var SpeedContainer = $TabContainer/General/ScrollContainer/GeneralOptionContainer/BaseContainer/VBoxContainer/Speed
onready var VsyncContainer = $TabContainer/General/ScrollContainer/GeneralOptionContainer/BaseContainer/VBoxContainer/Vsync


const save_dir = "user://Saves/Settings/"
const save_path = save_dir +"save_options.json"

var current_selected = 0
var max_selected = 1

var ui_state = Ui_state.Unactive

enum Ui_state {Unactive,Options,General,Styles,Text}

func _ready():
	load_data()
	SpeedContainer.connect("save",self,"save_data")
	VsyncContainer.connect("save",self,"save_data")

func _physics_process(_delta):
	visible = ui_state != Ui_state.Unactive
	if ui_state == Ui_state.General:
		if current_selected == 0:
			SpeedContainer._active()
		
		elif current_selected != 0:
			SpeedContainer._deactivate()
		
		if current_selected == 1:
			VsyncContainer._active()
		elif current_selected != 1:
			VsyncContainer._deactivate()
	else:
		SpeedContainer._deactivate()
		VsyncContainer._deactivate()
		

func _input(event):
	if ui_state == Ui_state.Options:
		max_selected = tabContainer.get_child_count() -1
		tabContainer.current_tab = current_selected
		tabContainer.get_child(current_selected).ensure_tab_visible(current_selected)
		if event.is_action_pressed("D"):
			if current_selected == max_selected:
				current_selected = 0
			else:
				current_selected += 1
		
		elif event.is_action_pressed("A"):
			if current_selected == 0:
				current_selected = max_selected
			else:
				current_selected -= 1
		
		elif event.is_action_pressed("S") or event.is_action_pressed("accept"):
			if current_selected == 0:
				ui_state = Ui_state.General
			elif current_selected == 1:
				ui_state = Ui_state.Styles
			elif current_selected == 2:
				ui_state = Ui_state.Text
		
		if event.is_action_pressed("decline"):
			current_selected = 0
			Utils.get_menu()._undisplay_option_menu()

	elif ui_state == Ui_state.General:
		max_selected = BaseContainer.get_child(0).get_child_count() - 1

		if event.is_action_pressed("W"):
			if current_selected == 0:
				ui_state = Ui_state.Options
			else:
				current_selected -= 1
		
		elif event.is_action_pressed("S"):
			if current_selected == max_selected:
				current_selected = 0
			else:
				current_selected += 1

		
		elif event.is_action_pressed("D"):
			if current_selected == 0:
				SpeedContainer._change_value(1)

		elif event.is_action_pressed("A"):
			if current_selected == 0:
				SpeedContainer._change_value(-1)
		
		if event.is_action_pressed("accept"):
			if current_selected == 1:
				VsyncContainer._toggle()
		
		if event.is_action_pressed("decline"):
			current_selected = 0
			ui_state = Ui_state.Options

func save_data():
	var data = {
		"Speed":SpeedContainer.get_speed(),
		"Vsync":VsyncContainer.get_pressed()
	}

	var dir = Directory.new()
	if !dir.dir_exists(save_dir):
		dir.make_dir_recursive(save_dir)

	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_line(to_json(data))
		file.close()

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var loadingData = JSON.parse(file.get_as_text()).result
			_apply_data(loadingData)
			file.close()

func _apply_data(data):
	SpeedContainer.set_speed(data.Speed)
	VsyncContainer.set_pressed(data.Vsync)
