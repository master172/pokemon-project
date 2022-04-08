extends Node2D

var current = false

onready var animation_player = $AnimationPlayer
func _ready():
	pass

func _physics_process(_delta):
	if current == true:
		animation_player.play("Default")
