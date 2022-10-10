extends Node2D

var scene
var current_pokemon

func _ready():
	if SceneLoaded.current_scene != null:
		self.get_child(0).queue_free()
		_instance()

func _apply_data():
	if self.get_child(0).has_method("load_game"):
		self.get_child(0).load_game()

func _instance():
	scene = load(String(SceneLoaded.current_scene))
	var scene_instance = scene.instance()
	self.add_child(scene_instance)
	if scene_instance.has_method("load_game"):
		scene_instance.load_game()

		

func save_game():
	if self.get_child_count() > 0:
		if self.get_child(0).has_method("save_game"):
			self.get_child(0).save_game()