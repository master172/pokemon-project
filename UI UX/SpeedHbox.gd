extends HBoxContainer

var speedvalue :float = 1.0

signal save

	

func get_speed():
	return speedvalue
	
func set_speed(speed):
	speedvalue = speed
	self.get_child(2).value = speedvalue
	self.get_child(1).text = String(speedvalue)+ "x"
	Engine.set_time_scale(speedvalue)

func _active():
	self.get_child(0).modulate = Color("00bdff")
	self.get_child(1).modulate = Color("00bdff")

func _deactivate():
	self.get_child(0).modulate = Color("ffffff")
	self.get_child(1).modulate = Color("ffffff")

func _change_value(value):
		if value == -1:
			if speedvalue -0.5 <= self.get_child(2).max_value and speedvalue -0.5 >= self.get_child(2).min_value: 
				speedvalue -= 0.5
				self.get_child(2).value = speedvalue
				self.get_child(1).text = String(speedvalue)+ "x"
				Engine.set_time_scale(speedvalue)
		elif value == 1:
			if speedvalue +0.5 <= self.get_child(2).max_value and speedvalue +0.5 >= self.get_child(2).min_value:
				speedvalue += 0.5
				self.get_child(2).value = speedvalue
				self.get_child(1).text = String(speedvalue)+ "x"
				Engine.set_time_scale(speedvalue)
		emit_signal("save")