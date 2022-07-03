extends Control

const option = preload("res://UI UX/Option.tscn")

onready var Text_displayer = $AnimationPlayer
onready var RichTextLabel = $NinePatchRect/RichTextLabel
onready var arrow = $Arrow

onready var Option_container = $Option_container

var text_to_diaplay : Array = ["Hello, World! Spam and Eggs this is gonna be exilirating lets get excited",
"Progress has been made", "We reached to infinite and beyond","lets try choices",1,"we finished choices",0]

var current_set = 0

var choices : Array = [["yes","you_choosed_first_option","so the answer is 1",1],["no","you_choosed_second_option","so the answer is 2",1]]
var to_choice = false

var option_array : Array = []
var current_choice = 0
var max_choices
var selected_choice
var choosed = false

var choice_var = 0

var handling_choice = false

signal Dialog_started
signal Dialog_ended

signal Dialog_skipped
signal Dialog_changed

signal choice_asked
signal choice_selected
signal _choice_number(choice)
signal choice_ended

func _ready():
	emit_signal("Dialog_started")
	Option_container.visible = false

	RichTextLabel.text = text_to_diaplay[0]
	$Arrow/AnimationPlayer.play("Still")
	Text_displayer.play("Text_display")

func _physics_process(delta):
	if to_choice == false:
		if Input.is_action_just_pressed("accept") and RichTextLabel.percent_visible != 1:
			Text_displayer.play("Text skip")
			$Arrow/AnimationPlayer.play("Idle")
			emit_signal("Dialog_skipped")
		elif Input.is_action_just_pressed("accept") and RichTextLabel.percent_visible == 1:
			if current_set < text_to_diaplay.size() - 1:
				if typeof(text_to_diaplay[current_set + 1]) != TYPE_INT:
					current_set += 1
					RichTextLabel.percent_visible = 0
					RichTextLabel.text = text_to_diaplay[current_set]
					Text_displayer.play("Text_display")
					emit_signal("Dialog_changed")
				elif typeof(text_to_diaplay[current_set + 1]) == TYPE_INT:
					if text_to_diaplay[current_set + 1] == 1:
						to_choice = true
						_ask_choice()
						emit_signal("choice_asked")
					elif text_to_diaplay[current_set + 1] == 0:
						emit_signal("Dialog_ended")
						queue_free()
		
	if handling_choice == true:
		
		
		if Input.is_action_just_pressed("accept") and RichTextLabel.percent_visible != 1:
			Text_displayer.play("Text skip")
			$Arrow/AnimationPlayer.play("Idle")
		elif Input.is_action_just_pressed("accept") and RichTextLabel.percent_visible == 1:
			
			if choice_var < option_array.size() -1:
				if typeof(option_array[choice_var + 1]) != TYPE_INT:
					choice_var += 1
					RichTextLabel.percent_visible = 0
					RichTextLabel.text = choices[selected_choice][choice_var]
					Text_displayer.play("Text_display")
				elif typeof(option_array[choice_var + 1]) == TYPE_INT:
					if option_array[choice_var + 1] == 1:
						emit_signal("choice_ended")
						_finish_choices()

func _handle_choice():
	RichTextLabel.text = choices[selected_choice][1]
	$Arrow/AnimationPlayer.play("Still")
	Text_displayer.play("Text_display")

func _finish_choices():	
	current_set += 1
	to_choice = false
	handling_choice = false
	choosed = false
	choice_var = 0
	for i in range(0,Option_container.get_child(1).get_child_count()):
		Option_container.get_child(1).get_child(i).queue_free()


func _input(event):
	if choosed == false and to_choice == true:
		if event.is_action_pressed("W"):
			if current_choice < max_choices -1:
				current_choice += 1
			else:
				current_choice = 0
			for i in Option_container.get_child(1).get_child_count():
				if i == current_choice:
					Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = true
					Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("ffffff")
				else:
					Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = false
					Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("afafaf")

		elif event.is_action_pressed("S"): 
			if current_choice > 0:
				current_choice -= 1
			else:
				current_choice = max_choices - 1
			for i in Option_container.get_child(1).get_child_count():
				if i == current_choice:
					Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = true
					Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("ffffff")
				else:
					Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = false
					Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("afafaf")
	
		if event.is_action_pressed("accept"):
			choosed = true
			selected_choice = current_choice
			emit_signal("choice_selected")
			emit_signal("_choice_number",selected_choice)
			option_array = choices[selected_choice]
			handling_choice = true
			_handle_choice()
			Option_container.visible = false

func _mid_choosing():
	max_choices = Option_container.get_child(1).get_child_count()
	
	for i in Option_container.get_child(1).get_child_count():
		if i == current_choice:
			Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = true
			Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("ffffff")
		else:
			Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = false
			Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("afafaf")
	
	
	if Input.is_action_just_pressed("S"):
		if current_choice < 0:
			current_choice -= 1
		else:
			current_choice = max_choices
		for i in Option_container.get_child(1).get_child_count():
			if i == current_choice:
				Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = true
				Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("ffffff")
			else:
				Option_container.get_child(1).get_child(i).get_child(0).get_child(0).visible = false
				Option_container.get_child(1).get_child(i).get_child(0).get_child(1).self_modulate = Color("afafaf")
	
	
	
	

func _ask_choice():
	Option_container.visible = true
	for i in choices:
		Option_container.get_child(1).add_child(option.instance())
		for k in Option_container.get_child(1).get_child_count():
			Option_container.get_child(1).get_child(k).get_child(0).get_child(1).text = choices[k][0]
			
		for j in Option_container.get_child(1).get_child_count():
			Option_container.rect_position.y -= 5


	_mid_choosing()
	

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "Text_display" || anim_name == "Text skip":
		$Arrow/AnimationPlayer.play("Idle")


func _on_AnimationPlayer_animation_started(anim_name:String):
	if anim_name == "Text_display":
		$Arrow/AnimationPlayer.play("Still")
