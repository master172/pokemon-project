extends CanvasLayer

var debug = false

func _ready():
	pass

func _physics_process(_delta):
	if OS.is_debug_build():

		get_node("%Fps_value").text = str(Performance.get_monitor(Performance.TIME_FPS))

		#setting visible
		if Input.is_action_just_pressed("debugF3"):
			if debug == false:
				debug = true
				self.visible = true
			elif debug == true:
				debug = false
				self.visible = false


func _on_VsyncBuuton_toggled(button_pressed:bool):
	if button_pressed == true:
		OS.set_use_vsync(true)
		print(OS.is_vsync_enabled())
	elif button_pressed == false:
		OS.set_use_vsync(false)
		print(OS.is_vsync_enabled())





func _on_Winbutton_pressed():
	print("calling function")
	if OpposingTrainerMonsters.pokemon != null:
		OpposingTrainerMonsters.pokemon.Current_health_points -= OpposingTrainerMonsters.pokemon.Current_health_points
		print("reducing hralth points")
		get_node("%Win_button").pressed = false
	else:
		get_node("%Win_button").pressed = false
		
