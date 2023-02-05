extends Control

onready var Play = $Play
onready var background = $Play/Background
onready var fore_ground = $Play/ForeGround

onready var quit = $Quit
onready var quit_background = $Quit/Background
onready var quit_fore_ground = $Quit/ForeGround

var current_selected = 0
var max_selected = 1

func _ready():
	pass
#012.2

func _new_game_selected():
	background.color = Color("00ff0a")


func _new_game_deselected():
	background.color = Color("008005")

func _quit_game_selected():
	quit_background.color = Color("00ff0a")


func _quit_game_deselected():
	quit_background.color = Color("008005")

func _physics_process(_delta):
	if current_selected == 0:
		_new_game_selected()
		_quit_game_deselected()
	elif current_selected == 1:
		_new_game_deselected()
		_quit_game_selected()

func _input(event):
	if event.is_action_pressed("W"):
		if current_selected == 0:
			current_selected = 1
		elif current_selected == 1:
			current_selected = 0
	elif event.is_action_pressed("S"):
		if current_selected == 0:
			current_selected = 1
		elif current_selected == 1:
			current_selected = 0
	elif event.is_action_pressed("D"):
		if current_selected == 0:
			current_selected = 1
		elif current_selected == 1:
			current_selected = 0
	elif event.is_action_pressed("A"):
		if current_selected == 0:
			current_selected = 1
		elif current_selected == 1:
			current_selected = 0

	if event.is_action_pressed("accept"):
		if current_selected == 1:
			get_tree().quit()
		elif current_selected == 0:
			SceneChanger.goto_scene("res://Scenes/SceneManager.tscn",self)
