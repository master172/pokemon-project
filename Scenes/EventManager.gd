extends Node2D

const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

onready var Dialogue_layer = get_parent().get_node("Dialog_layer")

var events = []

var current_event = null

var event_parameters = []

signal finished_event(event)

func _ready():
	pass

func _physics_process(delta):
	if events.size() > 0 and current_event == null and self.get_parent().ui_state != self.get_parent().Ui_state.Dialogue:

		current_event = events[0]
		events.remove(0)
	if current_event != null:
		if current_event == "critical_hit":
			if self.get_parent().get_child(13).get_child_count() == 0:
				_critical_hit()

func _critical_hit():
	self.get_parent().ui_state = self.get_parent().Ui_state.Dialogue
	var Dialogue = Dialog.instance()
	Dialogue.text_to_diaplay = ["A critical hit",0]
	Dialogue_layer.add_child(Dialogue)
	Dialogue.connect("Dialog_ended",self,"_finish_critical_hit")

func _finish_critical_hit():
	self.get_parent().ui_state = self.get_parent().Ui_state.Battle
	current_event = null
	emit_signal("finished_event",current_event)
