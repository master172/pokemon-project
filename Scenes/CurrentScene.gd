extends Node2D

var scene

func _ready():
	if SceneLoaded.current_scene != null:
		self.get_child(0).queue_free()
		_instance()

func _instance():
	scene= load(String(SceneLoaded.current_scene))
	var scene_instance = scene.instance()
	self.add_child(scene_instance)
