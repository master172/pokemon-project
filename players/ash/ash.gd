extends KinematicBody2D

#variables

#variables-->save_directory

const SAVE_DIR = "user://Saves/Player/"
const save_path = SAVE_DIR + "player_save.json"

var player_data
#variables-->signals

#variables-->signals-->looking_direction_signals


#variables-->signals-->moving_value_signals
signal player_moving_signal
signal player_stopped_signal

#variables-->signals-->entering_door_signals
signal player_entering_door_signal
signal player_entered_door_signal

#variables-->export

#variables-->export-->vector_movement_signal
export var walk_speed = 4.0
export var jump_speed = 4.0

#variables-->constants

#variables-->constants-->hard_required
const tile_size = 16

#variables-->constants-->prefabs
const LANDING_SUST_EFFECT = preload("res://libraries/landong_dust_effect.tscn")

#variables-->enums
#variables-->enums-->player_state
enum Player_state { idle , walking, turning, running, cycling, surfing }

#variables-->enums-->Looking/Facing_directions_state
enum Facing_direction { left, right, up, down }
enum Looking_direction {left, right, up, down}

#variables-->enum_states

#variables-->enum_states-->player_state
var player_state = Player_state.idle

#variables-->enum_state-->Looking/Facing_directions_state
var facing_direction = Facing_direction.left
var looking_direction = Looking_direction.left

#variables-->vector_variables

#variables-->vector_variables-->velocity
var velocity = Vector2()

#variables-->vector_variables-->initial_position
var initial_position = Vector2(0,0)

#variables-->vector_variables-->input_direction
var input_direction = Vector2(0,1)

#variables-->moving_variables
var is_moving: bool = false
var stop_input:bool = false
export(bool)var can_move:bool = true

#variables-->running_variables
export(bool)var can_run: bool = true
var is_running: bool = false

#variables-->cycling_variables
export(bool)var can_cycle: bool = true
var is_cycling: bool = false

#variables-->surfing_variables
var is_surfing: bool = false
export(bool)var can_surf: bool = true

#variables-->jumping_over_ledge
var jumpin_over_ledge : bool = false

#variables-->p.m.o.d
var percent_moved_to_next_tile = 0.0

#variables-->collision_variables
var colliding: bool = false
var collison_with_land:bool = false

#variables-->next_scene_to_go
onready var next_scene_to_go

#variables-->talking_variables
var is_talking : bool = false
var interacting = false
var current_interacted
var current_dialog_to_display = []

#variables-->grass_variables
var inside_grass

#variables-->onready_variables

#variables-->onready_variables-->visual_variables
onready var anim_player = $AnimatedSprite/AnimationTree
onready var anim_state = anim_player.get("parameters/playback")
onready var shadow = $Sprite

#variables-->onready_variables-->ray_variables
onready var ray = $RayCast2D
onready var ledge_ray = $RayCast2D2
onready var door_ray = $RayCast2D3
onready var interaction_ray = $RayCast2D4

#variables-->onready_variables-->detector_variables
onready var detector = $Area2D/detector
onready var plate = $Area2D


func _ready():
	#calling_the_load_function
	_load_data()

	

	#variables-->setter_variables-->setting
	$Sprite.visible = true
	anim_player.active = true
	initial_position = position
	velocity = position
	shadow.visible = false

	if self.facing_direction == Facing_direction.up:
		anim_player.set("parameters/idle/blend_position",Vector2(0,-1))
		anim_player.set("parameters/walk/blend_position",Vector2(0,-1))
		anim_player.set("parameters/turn/blend_position",Vector2(0,-1))
		anim_player.set("parameters/run/blend_position",Vector2(0,-1))
		anim_player.set("parameters/cycle/blend_position",Vector2(0,-1))
		anim_player.set("parameters/cycle_idle/blend_position",Vector2(0,-1))
		anim_player.set("parameters/surf/blend_position",Vector2(0,-1))
		anim_player.set("parameters/run_turn/blend_position",Vector2(0,-1))
	
	elif self.facing_direction == Facing_direction.left:
		anim_player.set("parameters/idle/blend_position",Vector2(1,0))
		anim_player.set("parameters/walk/blend_position",Vector2(1,0))
		anim_player.set("parameters/turn/blend_position",Vector2(1,0))
		anim_player.set("parameters/run/blend_position",Vector2(1,0))
		anim_player.set("parameters/cycle/blend_position",Vector2(1,0))
		anim_player.set("parameters/cycle_idle/blend_position",Vector2(1,0))
		anim_player.set("parameters/surf/blend_position",Vector2(1,0))
		anim_player.set("parameters/run_turn/blend_position",Vector2(1,0))
	
	elif self.facing_direction == Facing_direction.right:
		anim_player.set("parameters/idle/blend_position",Vector2(-1,0))
		anim_player.set("parameters/walk/blend_position",Vector2(-1,0))
		anim_player.set("parameters/turn/blend_position",Vector2(-1,0))
		anim_player.set("parameters/run/blend_position",Vector2(-1,0))
		anim_player.set("parameters/cycle/blend_position",Vector2(-1,0))
		anim_player.set("parameters/cycle_idle/blend_position",Vector2(-1,0))
		anim_player.set("parameters/surf/blend_position",Vector2(-1,0))
		anim_player.set("parameters/run_turn/blend_position",Vector2(-1,0))
	
	elif self.facing_direction == Facing_direction.down:
		anim_player.set("parameters/idle/blend_position",Vector2(0,1))
		anim_player.set("parameters/walk/blend_position",Vector2(0,1))
		anim_player.set("parameters/turn/blend_position",Vector2(0,1))
		anim_player.set("parameters/run/blend_position",Vector2(0,1))
		anim_player.set("parameters/cycle/blend_position",Vector2(0,1))
		anim_player.set("parameters/cycle_idle/blend_position",Vector2(0,1))
		anim_player.set("parameters/surf/blend_position",Vector2(0,1))
		anim_player.set("parameters/run_turn/blend_position",Vector2(0,1))

	#setting_the_anim_player_playback_method

func set_spawn(location: Vector2, direction: Vector2):

	#setting_the_playback_methods_on_changing_scenes
	anim_player.set("parameters/idle/blend_position",direction)
	anim_player.set("parameters/walk/blend_position",direction)
	anim_player.set("parameters/turn/blend_position",direction)
	anim_player.set("parameters/run/blend_position",direction)
	anim_player.set("parameters/cycle/blend_position",direction)
	anim_player.set("parameters/cycle_idle/blend_position",direction)
	anim_player.set("parameters/surf/blend_position",direction)
	anim_player.set("parameters/run_turn/blend_position",direction)
	position = location
	

func _interact():
	

	if interaction_ray.is_colliding():
		if !is_moving:
			if interaction_ray.get_collider().is_in_group("Interactable"):
				if Input.is_action_just_pressed("accept") and interacting == false:
					var sceneManager = Utils.Get_Scene_Manager()
					if sceneManager.get_child(6).get_child_count() == 0:
					
						interacting = true
						is_talking = true
						if interaction_ray.get_collider().has_method("_Start_dialog"):
							interaction_ray.get_collider()._Start_dialog()
							interaction_ray.get_collider().player = self
						elif interaction_ray.get_collider().has_method("_interact_out_put"):
							interaction_ray.get_collider()._interact_out_put()
							interacting = false
							is_talking = false
		

func interact_update():
	#updating_the_interaction_ray

	#changing_the_interaction_ray_position_according_to_our_lookin_direction
	if looking_direction == Looking_direction.left:
		interaction_ray.cast_to = Vector2(-8,0)
	elif looking_direction == Looking_direction.right:
		interaction_ray.cast_to = Vector2(8,0)
	elif looking_direction == Looking_direction.up:
		interaction_ray.cast_to = Vector2(0,-8)
	elif looking_direction == Looking_direction.down:
		interaction_ray.cast_to = Vector2(0,8)
	interaction_ray.force_raycast_update()
	

func _update_check():
	#checking_when_we_are_on_-x_cordinates
	var to_snap = null
	if input_direction == Vector2(0,0) and not is_surfing:
		if position.x < 0:
			if fmod(position.x,8) != 0:
				to_snap = stepify(position.x,1)
				position.x = stepify(position.x,1)
				if fmod(to_snap,8) != 0:
					if facing_direction == Facing_direction.left:
						position.x += int(position.x)%int(8)
					elif facing_direction == Facing_direction.right:
						position.x -= int(position.x)%int(8)
		#checking_when_we_are_on_+x_cordinates
		elif position.x > 0:
			if fmod(position.x,8) != 0:
				to_snap = stepify(position.x,1)
				position.x = stepify(position.x,1)
				if fmod(to_snap,8) != 0:
					if facing_direction == Facing_direction.right:
						position.x += int(position.x)%int(8)
					elif facing_direction == Facing_direction.left:
						position.x -= int(position.x)%int(8)
		#checking_when_we_are_on_-y_cordinates
		if position.y < 0:
			if fmod(position.y,8) != 0:
				to_snap = stepify(position.y,1)
				position.y = stepify(position.y,1)
				if fmod(to_snap,8) != 0:
					if facing_direction == Facing_direction.up:
						position.y -= int(position.y) % int(8)
					elif facing_direction == Facing_direction.down:
						position.y += int(position.y) % int(8)
		#checking_when_we_are_on_+y_cordinates
		elif position.y > 0:
			if fmod(position.y,8) != 0:
				to_snap = stepify(position.y,1)
				position.y = stepify(position.y,1)
				if fmod(to_snap,8) != 0:
					if facing_direction == Facing_direction.down:
						position.y -= int(position.y)%int(8)
					elif facing_direction == Facing_direction.up:
						position.y += int(position.y)%int(8)

func _physics_process(delta):
	#this_method_is_called_every_frame
	
	_update_check()
	
	#calling_the_interact_update_method and the interact method
	interact_update()
	
	#checking_if_we_are_interacting_and_performing_with_respect_to_it
	if is_talking:
		can_move = false
	else:
		can_move = true
	
	#calling_the_interact_method
	_interact()
	
	#checking_if_we_are_colliding_with_water
	if colliding:
		#meeting_the_requirments_for_surfing
		if Input.is_action_just_pressed("accept") and not is_surfing and can_surf and not is_cycling and not is_running and is_moving == false:
			is_surfing =  true

			#moving_to_the_water_based_on_the_facing_direction
			if facing_direction == Facing_direction.left:
				position += Vector2(16,0)
			elif facing_direction == Facing_direction.right:
				position -= Vector2(16,0)
			elif facing_direction == Facing_direction.up:
				position += Vector2(0,-16)
			elif facing_direction == Facing_direction.down:
				position += Vector2(0,16)
	
	#checking_if_we_are_colliding_with_land
	elif collison_with_land:
		#meeting_the_requirments_for_walking
		if Input.is_action_just_pressed("accept") and is_surfing and not is_cycling and not is_running and is_moving == false:
			

			#moving_to_the_land_based_on_the_facing_direction
			if facing_direction == Facing_direction.left:
				position += Vector2(16,0)
			if facing_direction == Facing_direction.right:
				position += Vector2(-16,0)
			if facing_direction == Facing_direction.up:
				position += Vector2(0,-16)
			if facing_direction == Facing_direction.down:
				position += Vector2(0,16)
			
			is_surfing = false

	#moving_the_collision_layer_while_surfing
	if is_surfing:
		ray.set_collision_mask_bit(0,false)
		ray.set_collision_mask_bit(1,true)
		$AnimatedSprite.position.y = -12
		ray.position.y = -8
	#reseting_the_collision_layer_after_surfing
	else:
		ray.set_collision_mask_bit(0,true)
		ray.set_collision_mask_bit(1,false)
		$AnimatedSprite.position.y = -10
		ray.position.y = -8

	
	#updating_the_facing_direction_based_on_input
	if input_direction.x >= 0.1:
		detector.position = Vector2(16,-8)
		looking_direction = Looking_direction.right
	elif input_direction.x <=-0.1:
		detector.position = Vector2(-16,-8)
		looking_direction = Looking_direction.left
	if input_direction.y >= 0.1:
		detector.position = Vector2(0,8)
		looking_direction = Looking_direction.down
	elif input_direction.y <= -0.1:
		detector.position = Vector2(0,-24)
		looking_direction = Looking_direction.up
	
	
	#meeting_the_requirments_for_cycling
	if Input.is_action_just_pressed("debug") and can_cycle and is_running == false and is_cycling == false and not is_surfing:
		is_cycling = true
	#metting_the_requirmenrs_for_getting_off_the_cycle
	elif Input.is_action_just_pressed("debug") and can_cycle and is_running == false and is_cycling == true and not is_surfing:
		is_cycling = false
	
	#setting_the+cycling_state
	if is_cycling == true:
		walk_speed = 16.0
		$AnimatedSprite.position.y = -11
	#reseting_the_cycling_state
	elif is_running == false and is_cycling == false:
		walk_speed = 4.0
		$AnimatedSprite.position.y = -10
	
	#meeting_the_requirments_for_running
	if Input.is_action_pressed("decline") and can_run and is_cycling == false and is_surfing == false:
		#setting_the_running_variables
		walk_speed = 8.0
		is_running = true
	
	#meeting_the_requirments_for_stooping_running
	elif is_cycling == false and is_surfing == false:
		#reseting_the_running_variables
		walk_speed = 4.0
		is_running = false
	
	#setting_the_turning_state
	if player_state == Player_state.turning or stop_input and can_move:
		return
	#processing_moving_input
	elif is_moving == false and can_move:
		process_player_input()
	
	#setting_the_animation_blender_according_to_the_current_state
	elif input_direction != Vector2.ZERO and can_move:
		if Input.is_action_pressed("decline") and can_run and input_direction != Vector2.ZERO and not is_cycling and not is_surfing:
			anim_state.travel("run")
		elif is_cycling == true and can_cycle and input_direction != Vector2.ZERO and not is_running and not is_surfing:
			anim_state.travel("cycle")
		elif is_surfing == true and can_surf and input_direction != Vector2.ZERO and not is_cycling and not is_running:
			anim_state.travel("surf")
		else:
			anim_state.travel("walk")
		move(delta)
	
	#setting_the_animation_blender_according_to_the_current_idle_state
	elif input_direction == Vector2.ZERO and can_move:
		if is_cycling == true  and velocity == Vector2.ZERO:
			anim_state.travel("cycle_idle")
			is_moving = false
		elif is_surfing == true and velocity == Vector2.ZERO:
			anim_state.travel("surf")
			is_moving = false
		elif is_cycling == false and velocity == Vector2.ZERO:
			anim_state.travel("idle")
			is_moving = false

#prossescing_the_player_input
func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	
	#animation_blender_playback_settings_while_reciving_input

	if input_direction != Vector2.ZERO:
		anim_player.set("parameters/idle/blend_position",input_direction)
		anim_player.set("parameters/walk/blend_position",input_direction)
		anim_player.set("parameters/turn/blend_position",input_direction)
		anim_player.set("parameters/run/blend_position",input_direction)
		anim_player.set("parameters/cycle/blend_position",input_direction)
		anim_player.set("parameters/cycle_idle/blend_position",input_direction)
		anim_player.set("parameters/surf/blend_position",input_direction)
		anim_player.set("parameters/run_turn/blend_position",input_direction)
			
		
		#turning_mechanics_acoording_to_current_player_state
		if need_to_turn():

			#setting_the_turning_state_according_to_the_player_state

			player_state = Player_state.turning
			if is_surfing:
				anim_state.travel("surf")
			elif is_cycling:
				anim_state.travel("cycle_idle")
			elif is_running:
				anim_state.travel("run_turn")
			else:
				anim_state.travel("turn")
		else:
			initial_position = position
			is_moving = true

	#setting_the_state_to_idle_if_no_input_is_recived

	else:
		if is_cycling == true:
			anim_state.travel("cycle_idle")
		elif is_surfing == true:
			anim_state.travel("surf")
		elif is_cycling == false:
			anim_state.travel("idle")

#turning_mechanics
func need_to_turn():
	var new_facing_direction
	#turning_according_to_input
	if input_direction.x > 0:
		new_facing_direction = Facing_direction.left
	elif input_direction.x < 0:
		new_facing_direction = Facing_direction.right
	elif input_direction.y < 0:
		new_facing_direction = Facing_direction.up
	elif input_direction.y > 0:
		new_facing_direction = Facing_direction.down
	
	#turning

	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	
	#finished_turning
	facing_direction = new_facing_direction
	return false

#resseting_the_turning_state_according_to_the_player_state
func finished_turning():
	if is_cycling:
		player_state = Player_state.cycling
	if is_surfing:
		player_state = Player_state.surfing
	player_state = Player_state.idle

#emmiting_entering_door_signal
func _entered_door():
	emit_signal("player_entered_door_signal")

#moving_mechanics
func move(delta):

	#setting_the_desired_position
	var desired_step: Vector2 = input_direction * tile_size / 2
	
	#updating_the_collision_ray
	ray.cast_to = desired_step
	ray.force_raycast_update()
	
	#updating_the_ledge_ray
	ledge_ray.cast_to = desired_step
	ledge_ray.force_raycast_update()
	
	#updating_the_door_ray
	door_ray.cast_to = desired_step
	door_ray.force_raycast_update()

	
	
	#changing_scene_if_the_door_ray_is_colliding
	if door_ray.is_colliding():
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_entering_door_signal")
		percent_moved_to_next_tile += walk_speed * delta
		#changing_scenes
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * tile_size)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			stop_input = true
			$AnimatedSprite/AnimationPlayer.play("dissapear")
			$Camera2D.clear_current()
		else:
			position = initial_position + (input_direction * tile_size * percent_moved_to_next_tile)
	
	#jumping_over_ledge_mechanics
	elif (ledge_ray.is_colliding() && input_direction == Vector2(0, 1)) or jumpin_over_ledge:
		percent_moved_to_next_tile += jump_speed * delta
		#jumping_over_ledge
		if percent_moved_to_next_tile >= 2.0:
			position = initial_position + (input_direction * tile_size * 2)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			jumpin_over_ledge = false
			shadow.visible = false
			
			var dust_effect = LANDING_SUST_EFFECT.instance()
			dust_effect.position = position
			get_tree().current_scene.add_child(dust_effect)
		
		#making_the_shadow_visible
		else:
			shadow.visible = true
			jumpin_over_ledge = true
			var input = input_direction.y * tile_size * percent_moved_to_next_tile
			position.y = initial_position.y + (-0.96 - 0.53 * input + 0.05 * pow(input, 2))
	
	#not_moving_id_the_collision_ray_is_colliding
	elif !ray.is_colliding():
		if percent_moved_to_next_tile == 0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * tile_size)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
			
			
		else:
			position = initial_position + (input_direction * tile_size * percent_moved_to_next_tile)
	else:
		is_moving = false


#setting_the_collision_variables_for_moving_between_collision_layers
func _on_Area2D_body_entered(body):
	if body.is_in_group("collideable"):
		colliding = true
	if body.is_in_group("land"):
		collison_with_land = true

#resseting_the_collision_variables_for_moving_between_collision_layers
func _on_Area2D_body_exited(body):
	if body.is_in_group("collideable"):
		colliding = false
	if body.is_in_group("land"):
		collison_with_land = false


#saving the player_data
func _save_data():
	#the data needed to be saved
	var data = {
		"pos_x": position.x,
		"pos_y": position.y,
		"facing_direction":facing_direction,
		"looking_direction":looking_direction,
		"is_surfing":is_surfing,
		"is_moving":is_moving,
		"is_running":is_running,
		"is_cycling":is_cycling,
		"is_talking":is_talking,
	}

	#creating the file and saving the data

	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path,File.WRITE)
	if error == OK:
		file.store_line(to_json(data))
		file.close()

#loading the player_data
func _load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path,File.READ)
		if error == OK:
			player_data = JSON.parse(file.get_as_text()).result
			file.close()
			_apply_data()


#applying the saved data to the player
func _apply_data():
	if player_data != null:
		self.position.x = player_data.pos_x
		self.position.y = player_data.pos_y
		self.facing_direction = player_data.facing_direction
		self.looking_direction = player_data.looking_direction
		self.is_surfing = player_data.is_surfing
		self.is_moving = player_data.is_moving
		self.is_running = player_data.is_running
		self.is_cycling = player_data.is_cycling
		player_data = null
	

