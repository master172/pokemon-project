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
export(int) var max_pp

var learned = false

var added = false

var damage

var targets

var weather

var effectiveness

export(NodePath) var special_effects = null

export(String, MULTILINE) var description

export(float,0,100) var Accuracy = 100.0

var unlearned = false

export(Texture) var type_image

export(int,"physical","status","special") var category

var to_add_crit = false

func save():
	var save_dict = {

		"learned":learned,
		"pp":pp,
		"added":added,
		"to_add":to_add,
		"can_add":can_add,
		"unlearned":unlearned,
	}
	return save_dict


func _calculate_damage():
	if self.special_effects == null:
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
		
		if crit == 2:
			to_add_crit = true
		else:
			to_add_crit = false
		

		var stab : float 
		if self.Types == current_holder.Type_1[0] or self.Types == current_holder.Type_2[0]:
			stab = 1.5
		else:
			stab = 1

		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_number = rng.randi_range(85,100)

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
		
		damage = ((((2 * current_holder.level/5+2)*current_holder.Current_attack * power / current_holder.opposing_pokemon.Current_defense)/50)+2)* stab * current_holder.Weakness * current_holder.Resistance * random_number/ 100
		if self.get_parent().get_parent() == PlayerPokemon:
			damage = damage * (PokeHelper.player_badjes + 1)
		damage = damage / targets * weather  * crit* effectiveness

		print(self.get_parent().Name + " : damage =  " + String(damage) + " random number: " + String(random_number /100) + " stab = " + String(stab) + " weather = " + String(weather) + " crit = " + String(crit) + " effectiveness = " + String(effectiveness))
		_apply_damage()
	elif self.special_effects != null :
		get_node(special_effects)._attack()

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
			if self.get_parent().get_parent() == PlayerPokemon:
				BattleManager.PlayerLastMoveEvaded = true
			elif self.get_parent().get_parent() == OpposingTrainerMonsters:
				BattleManager.EnemyLastMoveEvaded = true
			
		elif damage >= 1:
			self.current_holder.opposing_pokemon.Current_health_points -= int(damage)
			if to_add_crit == true:
				Utils.Get_Pokemon_Manger().get_child(0).get_child(0).events.append("critical_hit")
				to_add_crit = false

	elif is_missed == true:
		print("missed")
		if self.get_parent().get_parent() == PlayerPokemon:
			BattleManager.PlayerLastMoveMissed = true
		elif self.get_parent().get_parent() ==OpposingTrainerMonsters:
			BattleManager.EnemyLastMoveMissed = true
		

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
					Utils.Get_Scene_Manager().PokemonSceneMoveLearningDialog(self)
				elif current_holder.Learned_moves.size() == 4:
					PlayerPokemon.current_learning_pokemon = self.current_holder
					MoveLearner.target_pokemon = self.current_holder
					MoveLearner.move_to_learn = self
					Utils.Get_Scene_Manager().transition_to_Move_learner(self)
					

func _ready():
	
	yield(get_tree().create_timer(0.2),"timeout")
	if self.get_parent() != null:
		current_holder = self.get_parent()
	if to_add == true:
		current_holder.learn(self)
	

func _check_to_add():
	if learned == true and to_add == false:
		to_add = true
	elif learned == true and to_add == true:
		to_add = true

func _heal():
	pp = max_pp
