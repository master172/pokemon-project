extends Control


func _ready():
	pass

func _physics_process(_delta):
	for i in range (0,self.get_child(0).get_child_count()):
		if self.get_child(0).get_child(i).rect_position.x > 98:
			self.get_child(0).get_child(i).rect_position.x = 0

		elif self.get_child(0).get_child(i).rect_position.x < 0:
			self.get_child(0).get_child(i).rect_position.x = 98
