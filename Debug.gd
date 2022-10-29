extends CanvasLayer

var debug = false

onready var VsyncButton = $Control/V_sync/V_sync_Buuton

func _ready():
	pass
	

func _physics_process(_delta):
	if VsyncButton.pressed != OS.is_vsync_enabled():
		VsyncButton.pressed = OS.is_vsync_enabled()
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
	elif button_pressed == false:
		OS.set_use_vsync(false)





func _on_Winbutton_pressed():
	if OpposingTrainerMonsters.pokemon != null:
		OpposingTrainerMonsters.pokemon.Current_health_points -= OpposingTrainerMonsters.pokemon.Current_health_points
		get_node("%Win_button").pressed = false
	else:
		get_node("%Win_button").pressed = false
		


func _on_Lose_button_pressed():
	if PlayerPokemon.current_pokemon != null:
		PlayerPokemon.current_pokemon.Current_health_points -= PlayerPokemon.current_pokemon.Current_health_points
		get_node("%Lose_button").pressed = false
	else:
		get_node("%Lose_button").pressed = false


func _on_Total_loss_pressed():
	var SceneManager = Utils.Get_Scene_Manager()
	if SceneManager.get_child(1).get_child_count() > 0:
		SceneManager.get_child(1).get_child(0)._total_loss_process()
