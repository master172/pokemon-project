extends Node2D
class_name Moves

export(bool) var can_add = true
var to_add = false

export(int) var power

onready var SAVE_KEY = "_party_number_" + name

export(String) var Name = ""

export(int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Types

export(int) var learned_level

var current_holder

export(int) var pp 

var learned = false

var added = false

var damage

var targets

var weather

var effectiveness

export(Resource) var special_effects 

export(String, MULTILINE) var description

export(float,0,100) var Accuracy = 100.0

var unlearned = false



func save():
	var save_dict = {
		"learned":learned,
		"current_holder" : current_holder,
		"pp":pp,
		"added":added,
		"to_add":to_add,
		"can_add":can_add,
		"unlearned":unlearned,
	}
	return save_dict


func _calculate_damage():
	if self.current_holder.opposing_pokemon.Weak_to.has(self.Types):
		effectiveness = 4
	elif self.current_holder.opposing_pokemon.Resistant_to.has(self.Types):
		effectiveness = 0.5
	else:
		effectiveness = 1
	var crit : int = 1
	var critical = RandomNumberGenerator.new()
	critical.randomize()
	var critical_damage = critical.randi_range(0,8)
	if critical_damage == 8:
		crit = 2
	else:
		crit = 1
	var stab : float 
	if self.Types == current_holder.Type_1[0] and self.Types == current_holder.Type_2[0]:
		stab = 2.0
	elif self.Types == current_holder.Type_1[0] and self.Types != current_holder.Type_2[0]:
		stab = 1.5
	elif self.Types != current_holder.Type_1[0] and self.Types != current_holder.Type_2[0]:
		stab = 1.0
	else:
		stab = 0.5
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_number = rng.randi_range(1,100)

	if PokeHelper.current_weather == PokeHelper.weathers[1]:
		weather = 1
	elif PokeHelper.current_weather == PokeHelper.weathers[0]:
		if self.Types == Types[2]:
			weather = 2
		elif self.Types == Types[11]:
			weather = 0.5
		else:
			weather = 1
	elif PokeHelper.current_weather == PokeHelper.weathers[2]:
		if self.Types == Types[11]:
				weather = 2
		elif self.Types == Types[2]:
			weather = 0.5
		else:
			weather = 1
		
	if current_holder.get_parent() == PlayerPokemon:
		targets = PlayerPokemon.targets
	elif current_holder.get_parent() == OpposingTrainerMonsters:
		targets = OpposingTrainerMonsters.targets
	
	damage = ((((((2 * current_holder.level)/5)+2)*current_holder.Current_attack * power / current_holder.opposing_pokemon.Current_defense)/50)+2)* stab * current_holder.Weakness * current_holder.Resistance * random_number/ 100
	damage = damage / targets * weather * (PokeHelper.player_badjes + 1) * crit* effectiveness
	_apply_damage()


func _apply_damage():
	var Missing = RandomNumberGenerator.new()
	Missing.randomize()
	var missing = Missing.randi_range(0,Accuracy)
	var is_missed : bool = false
	if Accuracy >= 100:
		is_missed = false
	elif Accuracy <= 99:
		if missing == Accuracy: 
			is_missed = true
		elif missing != Accuracy: 
			is_missed = false
	if is_missed == false:
		if damage <= 1:
			print("evaded")
			print(damage)
		elif damage >= 1:
			self.current_holder.opposing_pokemon.Current_health_points -= damage
			print("damaged")
			print("damage :", " ",damage)
			print("opposistions_health :"," ",self.current_holder.opposing_pokemon.Current_health_points)
	elif is_missed == true:
		print("missed")

func _physics_process(_delta):
	if self.get_parent() != null:
		current_holder = self.get_parent()
	

func _start_learning():
	if self.current_holder != null:
		if current_holder.level >= self.learned_level and can_add == true:
			if learned == false and unlearned == false:
				MoveLearner.learning = true
				MoveLearner.target_pokemon = self.current_holder
				MoveLearner.move_to_learn = self
				if current_holder.Learned_moves.size() <= 3:
					current_holder.learn(self)
					learned = true
				elif current_holder.Learned_moves.size() == 4:
					PlayerPokemon.current_learning_pokemon = self.current_holder
					MoveLearner.target_pokemon = self.current_holder
					MoveLearner.move_to_learn = self
					Utils.Get_Scene_Manager().transition_to_Move_learner()
					

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	if to_add == true:
		current_holder.learn(self)
	

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if learned == true and to_add == false:
			to_add = true
		elif learned == true and to_add == true:
			to_add = true
