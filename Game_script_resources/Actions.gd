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

export(int) var speed = 0

export(int) var priority = 0

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

	if self.speed == 0:
		self.speed = self.current_holder.Current_speed
	else:
		self.speed = self.speed

	self.current_holder._calc_weak_and_res()
	print(self.Name)
	if self.special_effects == null:
		if self.current_holder.opposing_pokemon.Weak_to.has(self.Types):
			effectiveness = 2
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
			if self.current_holder.get_parent() == PlayerPokemon:
				self.current_holder.opposing_pokemon.Current_health_points -= int(damage)
				Utils.Get_Pokemon_Manger().get_child(0).enemy_turn()
				if to_add_crit == true:
					Utils.Get_Pokemon_Manger().get_child(0).get_child(0).events.append("critical_hit")
					to_add_crit = false
			elif self.current_holder.get_parent() == OpposingTrainerMonsters:
				self.current_holder.opposing_pokemon.Current_health_points -= int(damage)
				Utils.Get_Pokemon_Manger().get_child(0).enemy_turn()
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
	if get_tree().current_scene.get_name() != "SceneManager":  
		yield(Utils,"loaded")
		yield(get_tree().create_timer(0.2),"timeout")
		
		if self.current_holder != null:
			if self.current_holder.get_parent() == PlayerPokemon:
				if current_holder.level >= self.learned_level and can_add == true:
					if learned == false and unlearned == false:
						MoveLearner.learning = true
						MoveLearner.target_pokemon = self.current_holder
						MoveLearner.move_to_learn = self
						if current_holder.Learned_moves.size() <= 3:
							current_holder.learn(self)
							learned = true
							print_debug(self.name + " suspect 3.0")
							Utils.Get_Scene_Manager().PokemonSceneMoveLearningDialog(self)
						elif current_holder.Learned_moves.size() == 4:
							PlayerPokemon.current_learning_pokemon = self.current_holder
							MoveLearner.target_pokemon = self.current_holder
							MoveLearner.move_to_learn = self
							Utils.Get_Scene_Manager().transition_to_Move_learner(self)
			elif self.current_holder.get_parent() == OpposingTrainerMonsters:
				if current_holder.level >= self.learned_level and can_add == true:
					if learned == false and unlearned == false:
						MoveLearner.learning = true
						MoveLearner.target_pokemon = self.current_holder
						MoveLearner.move_to_learn = self
						if current_holder.Learned_moves.size() <= 3:
							current_holder.learn(self)
							learned = true
							print_debug(self.name + " suspect 3.0")
						elif current_holder.Learned_moves.size() == 4:
							randomize()
							var rand = randi() % 4
							current_holder.Learned_moves.remove(rand)
							current_holder.learn(self)
							learned = true
							print_debug(self.name + " suspect 3.0")
	else:
		if self.current_holder != null:
			if self.current_holder.get_parent() == PlayerPokemon:
				if current_holder.level >= self.learned_level and can_add == true:
					if learned == false and unlearned == false:
						MoveLearner.learning = true
						MoveLearner.target_pokemon = self.current_holder
						MoveLearner.move_to_learn = self
						if current_holder.Learned_moves.size() <= 3:
							current_holder.learn(self)
							learned = true
							print_debug(self.name + " suspect 3.0")
							Utils.Get_Scene_Manager().PokemonSceneMoveLearningDialog(self)
						elif current_holder.Learned_moves.size() == 4:
							PlayerPokemon.current_learning_pokemon = self.current_holder
							MoveLearner.target_pokemon = self.current_holder
							MoveLearner.move_to_learn = self
							Utils.Get_Scene_Manager().transition_to_Move_learner(self)
			elif self.current_holder.get_parent() == OpposingTrainerMonsters:
				if current_holder.level >= self.learned_level and can_add == true:
					if learned == false and unlearned == false:
						MoveLearner.learning = true
						MoveLearner.target_pokemon = self.current_holder
						MoveLearner.move_to_learn = self
						if current_holder.Learned_moves.size() <= 3:
							current_holder.learn(self)
							learned = true
							print_debug(self.name + " suspect 3.0")
						elif current_holder.Learned_moves.size() == 4:
							randomize()
							var rand = randi() % 4
							current_holder.Learned_moves.remove(rand)
							current_holder.learn(self)
							learned = true
							print_debug(self.name + " suspect 3.0")
					

func _ready():
	
	yield(get_tree().create_timer(0.2),"timeout")

	
	if self.get_parent() != null:
		current_holder = self.get_parent()
	if to_add == true:
		current_holder.learn(self)
	if self.speed == 0:
		self.speed = self.current_holder.Current_speed
	else:
		self.speed = self.speed

func _check_to_add():
	if learned == true and to_add == false:
		to_add = true
	elif learned == true and to_add == true:
		to_add = true

func _heal():
	pp = max_pp

func _check_speed():
	if BattleManager.multi_battle == false:
		if self.current_holder != null:
			if self.current_holder == PlayerPokemon.current_pokemon:
				if PlayerPokemon.opposing_pokemon != null:
					_chec_diff()

func _chec_diff():
	var order
	order = priority + self.speed + self.current_holder.Current_speed
	
	var opposingOrder
	opposingOrder = OpposingTrainerMonsters.pokemon.Learned_moves[OpposingTrainerMonsters.movesToGo[1]].priority +OpposingTrainerMonsters.pokemon.Learned_moves[OpposingTrainerMonsters.movesToGo[1]].speed + OpposingTrainerMonsters.pokemon.Current_speed
	
	_organizeSingle(order,opposingOrder)

func _organizeSingle(order1,order2):
	print(order1,order2)
	if order1 > order2:
		_player_attack_first()
	elif order2 > order1:
		_player_attack_first()
	else:
		_player_attack_first()

func _player_attack_first():
	if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
		Utils.Get_Pokemon_Manger().get_child(0)._player_attack_dialogue(self)
		yield(Utils.Get_Pokemon_Manger().get_child(0),"playerDialogueFinished")
		_calculate_damage()

func _enemy_attack_first():
	pass
	
func _check_diff2():
	if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
		print("check_speed")
		if self.speed > self.current_holder.opposing_pokemon.Current_speed:
			if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
				Utils.Get_Pokemon_Manger().get_child(0)._player_attack_dialogue(self)
				yield(Utils.Get_Pokemon_Manger().get_child(0),"playerDialogueFinished")
				if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
					_calculate_damage()
		elif self.speed == self.current_holder.opposing_pokemon.Current_speed:
			if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
				Utils.Get_Pokemon_Manger().get_child(0)._player_attack_dialogue(self)
				yield(Utils.Get_Pokemon_Manger().get_child(0),"playerDialogueFinished")
				if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
					_calculate_damage()
		else:
			yield(BattleManager, "TurnChangedTrainer")
			print("turn changed")
			if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
				Utils.Get_Pokemon_Manger().get_child(0)._player_attack_dialogue(self)
				yield(Utils.Get_Pokemon_Manger().get_child(0),"playerDialogueFinished")
				if self.current_holder.fainted == false and self.current_holder == PlayerPokemon.current_pokemon:
					_calculate_damage()
