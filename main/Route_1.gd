extends YSort


func _ready():
	visible = false
	yield(get_tree().create_timer(0.2),"timeout")
	if PlayerPokemon.first_pokemon != null:
		$Route_1_fences.set_cell(0,-8,-1)
		$Route_1_fences.set_cell(-1,-8,-1)

	

func _on_VisibilityNotifier2D_screen_entered():
	visible = true
	set_physics_process(true)
	set_process(true)


func _on_VisibilityNotifier2D_screen_exited():
	visible = false
	set_physics_process(false)
	set_process(false)
