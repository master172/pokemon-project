extends Node2D

var Max_location = -130
var Min_location = 274

var current = false
var num = 0

onready var anim_player = $AnimationPlayer

func _ready():
	pass

func _physics_process(_delta):
	if self.position.x == 72:
		anim_player.play("Default")
	else:
		anim_player.play("Side_stepped")
	if self.position.x < Max_location:
		self.position.x = Min_location
	if self.position.x > Min_location:
		self.position.x = Max_location

