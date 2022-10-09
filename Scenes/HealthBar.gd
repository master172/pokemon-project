extends ProgressBar


func _ready():
	pass

func _physics_process(_delta):
	var colorPercentage = self.max_value / 6

	if self.value >= colorPercentage * 3:
		self.modulate = Color("00ff52")

	elif self.value >= colorPercentage:
		self.modulate = Color("ecff00")

	elif self.value <= colorPercentage:
		self.modulate = Color("ff0000")
	
	
	
	