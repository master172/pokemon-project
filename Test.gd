extends Node2D

var a ="Alphabet"
var b = "box"
var i = 0
var array = ["Alphabet",1]

func _ready():
	if array.has("erase"):
		array.erase("erase")
		print(array)
	else:
		array.append("erase")
		print(array)

func _physics_process(delta):
	
	if Input.is_action_just_pressed("tesy"):
		print("middle" + String(i))
		i += 1
