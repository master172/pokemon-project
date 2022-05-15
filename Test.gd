extends Node2D

var a ="Alphabet"
var b = "box"

var array = ["Alphabet",1]

func _ready():
	if array.has("erase"):
		array.erase("erase")
		print(array)
	else:
		array.append("erase")
