extends Node

var learning = false

var move_to_learn
var target_pokemon

func _ready():
	pass

func _cancel_learning():
	if target_pokemon != null and move_to_learn != null:
		move_to_learn.unlearned = true
		move_to_learn.learned = false
		move_to_learn.can_add = false
		move_to_learn.to_add = false
	yield(get_tree().create_timer(0.2),"timeout")
	move_to_learn = null
	target_pokemon = null
	
	Utils.Get_Scene_Manager().transition_exit_Move_learner()



	
func _make_to_learn(index,deleting_move):
	if target_pokemon != null and move_to_learn != null:
		target_pokemon.Learned_moves[index] = move_to_learn
		move_to_learn.learned = true
		target_pokemon._unlearn(deleting_move)
	yield(get_tree().create_timer(0.2),"timeout")
	move_to_learn = null
	target_pokemon = null
	index = 0
	
	Utils.Get_Scene_Manager().transition_exit_Move_learner()

	

func _physics_process(_delta):
	if learning == true:
		return
