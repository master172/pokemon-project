extends ColorRect


func _ready():
	pass

func _process(_delta):
	var time =OS.get_time()
	var timeinseconds = time.hour * 3600 + time.minute * 60 + time.second
	var currentframe = range_lerp(timeinseconds,0,86400,0,24)
	$AnimationPlayer.play("Day_night_cycle")
	$AnimationPlayer.seek(currentframe)