extends Node2D
class_name Pokemon

var stats_calculated : bool = false

var rng_move

var evolver

var exp_given :bool = false

var exp_gained : float = 0

export(float) var base_experience_yeild

var change_path

var change_pc_poke

export(int,1,3) var current_stage = 1
var added:bool
var name_changed :bool = false

var in_battle = false

export(Texture) var sprite 

export(String) var Name = ""
export(int) var id 

export var nature : String

export(Array, int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Type_1

export(Array, int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Type_2


export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Damage_normally_by = null

export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Weak_to = null

export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Resistant_to = null

export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Immune_to = null


export(int,0,100) var level_to_next_form
export(Array,Resource) var abilites 

export(Array,Resource) var Learned_moves

export(float) var catch_rate

export(String,"Fast","Slow","Medium_slow","Medium_fast","Erratic","Fluctuating") var Levelling_rate 

export(int) var Min_Hatch_time
export(int) var Max_Hatch_time

export(String,"50.0%_male","87.5%_male","25.0%_male","0%_male","100%_male") var gender_ratio

export(int,FLAGS,"Monster","Human-Like","Water 1","Water 3","Bug","Mineral","Flying","Amorphous","Field","Water 2","Fairy","Ditto","Grass","Dragon","No Eggs Discovered","Gender unknown") var egg_groups

export(int)var  base_friend_ship
export(float)var  height
export(float)var  weight

export(int,"confused","frozen","burned","paralyzed","poisoned","none") var status_effect 

var Max_health_points
var Max_attack
var Max_special_attack
var Max_defense
var Max_special_defense
var Max_speed

var Current_health_points = 0
var Current_attack = 0
var Current_defense = 0
var Current_special_attack = 0
var Current_special_defense = 0
var Current_speed= 0

export(String) var Base_stats
export(int) var base_Health_points
export(int) var base_attack
export(int) var base_special_attack
export(int) var base_defense
export(int) var base_special_defense
export(int) var base_speed


var EV_Health_points = 0
var EV_attack = 0
var EV_special_attack = 0
var EV_defense = 0
var EV_special_defense = 0
var EV_speed = 0


var IV_Health_points = 0
var IV_attack = 0
var IV_special_attack = 0
var IV_defense = 0
var IV_special_defense = 0
var IV_speed = 0

export(int)var hp_yield 
export(int)var attack_yield 
export(int)var defense_yield 
export(int)var speed_yield
export(int)var sp_attack_yield
export(int)var sp_defense_yield

export(String,MULTILINE) var pokemon_entry 

export(PackedScene) var next_form

var can_battle :bool = false
var fainted = false

var Weakness : float = 1
var Resistance : float = 1

var gender


var level : int = 0
var experince_gained :int = 0
var experince_to_next_level :float = 0
var experince_to_this_level :float = 0
var max_level:int = 100

var opposing_pokemon
signal enemy_lost(exp_to_give)
signal level_up(lev)
var current_holder

var hunger = 0
var energy = 0
var frendship = 0


func _calculate_exp_points_to_give():
	var _opposition_level
	var _battle_type
	var _targets
	var _win_type
	var _turns
	_turns = BattleManager.turns
	if BattleManager.catched == true and BattleManager.fainted == false:
		_win_type = 1
	elif BattleManager.catched == false and BattleManager.fainted == true:
		_win_type = 2
	if self.get_parent() == OpposingTrainerMonsters:
		_targets = PlayerPokemon.targets
	if self.opposing_pokemon != null:
		_opposition_level = self.opposing_pokemon.level
	else:
		_opposition_level = 0 
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		_battle_type = 1
	else:
		_battle_type = 2

	exp_gained = ((self.base_experience_yeild * self.level))/7
	
	if exp_gained < 0:
		exp_gained = exp_gained*-1
	else:	
		exp_gained = exp_gained





func _lose():
	print("lose")
	print(self.Current_health_points)
	_calculate_exp_points_to_give()
	
	if self.get_parent() == OpposingTrainerMonsters:
		BattleManager.turns = 0
		emit_signal("enemy_lost")
	
		if self.opposing_pokemon != null:
			for i in BattleManager.BatteledPokemon:
				print(i.Name)
				BattleManager.BatteledExperiece.append(exp_gained)
				i.experince_gained += exp_gained
				_add_ev_yield()
				i._level_up()
	
	elif self.get_parent() == PlayerPokemon:
		PlayerPokemon._active_pokemon()
		BattleManager.turns = 0

	
func _calculate_gender():
	var tempGender
	var genderRng = RandomNumberGenerator.new()
	genderRng.randomize()
	if self.gender_ratio == "50.0%_male":
		tempGender = genderRng.randi_range(0,1)
		if tempGender == 0:
			gender = "male"
		else:
			gender = "female"

	elif self.gender_ratio == "25.0%_male":
		tempGender = genderRng.randi_range(0,3)
		if tempGender == 0:
			gender = "male"
		else:
			gender = "female"

	elif self.gender_ratio == "87.5%_male":
		tempGender = genderRng.randi_range(0,3)
		if tempGender != 0:
			gender = "male"
		else:
			gender = "female"
	
	elif self.gender_ratio == "0%_male":
		gender = "female"
	
	elif self.gender_ratio == "100%_male":
		gender = "male"
	
	
			

func _level_up():
	if experince_to_next_level != 0:
		if experince_gained >= experince_to_next_level:
			_update_level()
			_add_stats()

func _add_ev_yield():
	
	if BattleManager.multi_battle == false:
		if PlayerPokemon.current_pokemon != null:
			PlayerPokemon.current_pokemon.EV_Health_points += self.hp_yield 
			PlayerPokemon.current_pokemon.EV_attack += self.attack_yield
			PlayerPokemon.current_pokemon.EV_defense += self.defense_yield
			PlayerPokemon.current_pokemon.EV_special_attack += self.sp_attack_yield
			PlayerPokemon.current_pokemon.EV_special_defense += self.sp_defense_yield
			PlayerPokemon.current_pokemon.EV_speed += self.speed_yield

func _add_stats():
	self.Max_health_points += self.EV_Health_points
	self.Max_attack += self.EV_attack 
	self.Max_defense += self.EV_defense 
	self.Max_special_attack += self.EV_special_attack
	self.Max_special_defense += self.EV_special_defense
	self.Max_speed +=  self.EV_speed

	
func _ready():
	
	if name_changed == false:
		self.name = "Pokemon_" + String(Utils.Num_loaded_pokemon) + "_" + name
		Utils.Num_loaded_pokemon += 1
		name_changed = true
	
	
	yield(get_tree().create_timer(0.2),"timeout")
	
	_calculate_experience_current_level()

	_calculate_stats()
	
	_check_move_to_learn()

	if added == true:
		if self.change_pc_poke != null:
			change_path = change_pc_poke
			PlayerPokemon.pc_pokemon.append(self)
		if change_path == "first_pokemon":
			PlayerPokemon.first_pokemon = self
		elif change_path == "second_pokemon":
			PlayerPokemon.second_pokemon = self
		elif change_path == "third_pokemon":
			PlayerPokemon.third_pokemon = self
		elif change_path == "fourth_pokemon":
			PlayerPokemon.fourth_pokemon = self
		elif change_path == "fifth_pokemon":
			PlayerPokemon.fifth_pokemon = self
		elif change_path == "sixth_pokemon":
			PlayerPokemon.sixth_pokemon = self

func _calculate_experience():
	if Levelling_rate == "Fast":
		experince_to_next_level = (4*pow(level,3)/5)
	elif Levelling_rate == "Medium_fast":
		experince_to_next_level = (pow(level,3))
	elif Levelling_rate == "Medium_slow":
		experince_to_next_level = (6/5*pow(level,3) - 15*pow(level,2) + 100*level - 140)
	elif Levelling_rate == "Slow":
		experince_to_next_level = (5*pow(level,3)/4)
	elif Levelling_rate == "Erratic":
		if level < 50:
			experince_to_next_level = (pow(level,3)*(100-level)/50)
		elif level > 50 and level < 68:
			experince_to_next_level = (pow(level,3)*(150 - level)/100)
		elif level > 68 and level < 98:
			experince_to_next_level = (pow(level,3)*((1911 - 10*level)/3.0)/500)
		elif level > 98 and level < 100:
			experince_to_next_level = ((pow(level,3)*(160-level))/100)
	elif Levelling_rate == "Fluctuating":
		if level < 15:
			experince_to_next_level = (pow(level,3)*((level+1)/3.0 + 24)/50)
		elif 15 < level and level < 36:
			experince_to_next_level = (pow(level,3)*((level+14)/50.0))
		elif 36 < level and level < 100:
			experince_to_next_level = pow(level,3)*(((level/2.0)+32)/50)
	_update_level()
	_calculate_experience_current_level()

func _calculate_experience_current_level():
	if Levelling_rate == "Fast":
		experince_to_this_level = (4*pow((level-1),3)/5)
	elif Levelling_rate == "Medium_fast":
		experince_to_this_level = (pow((level-1),3))
	elif Levelling_rate == "Medium_slow":
		experince_to_this_level = (6/5*pow((level-1),3) - 15*pow((level-1),2) + 100*(level-1) - 140)
	elif Levelling_rate == "Slow":
		experince_to_this_level = (5*pow((level-1),3)/4)
	elif Levelling_rate == "Erratic":
		if (level-1) < 50:
			experince_to_this_level = (pow((level-1),3)*(100-(level-1))/50)
		elif (level-1) > 50 and (level-1) < 68:
			experince_to_this_level = (pow((level-1),3)*(150 - (level-1))/100)
		elif (level-1) > 68 and (level-1) < 98:
			experince_to_this_level = (pow((level-1),3)*((1911 - 10*(level-1))/3.0)/500)
		elif (level-1) > 98 and (level-1) < 100:
			experince_to_this_level = ((pow((level-1),3)*(160-(level-1)))/100)
	elif Levelling_rate == "Fluctuating":
		if (level-1) < 15:
			experince_to_this_level = (pow((level-1),3)*(((level-1)+1)/3.0 + 24)/50)
		elif 15 < (level-1) and (level-1) < 36:
			experince_to_this_level = (pow((level-1),3)*(((level-1)+14)/50.0))
		elif 36 < (level-1) and (level-1) < 100:
			experince_to_this_level = pow((level-1),3)*((((level-1)/2.0)+32)/50)

func _update_level():
	if experince_to_next_level != 0:
		if experince_gained >= experince_to_next_level:
			level += 1
			
			BattleManager.BatteledLevelPokemon.append(self)
			BattleManager.BatteledLevelUp.append(self.level)

			print("emmited level up signal")
			emit_signal("level_up",level)
			_calculate_experience()
			
	if self.get_parent() == PlayerPokemon:
		PlayerPokemon._check_move_learning(self)
		if self.level >= self.level_to_next_form and self.next_form != null:
			PlayerPokemon._check_evolution(self)
		

func _calculate_stats():
	
	if stats_calculated == false:
		_calculate_health_points()
		_calculate_attack()
		_calculate_defense()
		_calculate_special_attack()
		_calculate_special_defense()
		_calculate_speed()
		Claculate_Init_stats()
		stats_calculated = true
		

func Claculate_Init_stats():
	self.Current_health_points += ((((self.base_Health_points *2 + self.IV_Health_points + (self.EV_Health_points/4))*self.level)/100 )+ 10 + level) 
	self.Current_attack += ((((self.base_attack * 2 + self.IV_attack + (self.EV_attack/4))*self.level)/100) + 5) * 1
	self.Current_defense += ((((self.base_defense * 2 + self.IV_defense + (self.EV_defense/4))*self.level)/100) + 5) * 1
	self.Current_special_attack += ((((self.base_special_attack * 2 + self.IV_special_attack + (self.EV_special_attack/4))*self.level)/100) + 5) * 1
	self.Current_special_defense += ((((self.base_special_defense * 2 + self.IV_special_defense + (self.EV_special_defense/4))*self.level)/100) + 5) * 1
	self.Current_speed += ((((self.base_speed * 2 + self.IV_speed + (self.EV_speed/4))*self.level)/100) + 5) * 1

func _calculate_speed():
	var stats_rng_6 = RandomNumberGenerator.new()
	stats_rng_6.randomize()
	IV_attack += stats_rng_6.randi_range(0,32)
	Max_speed = ((((self.base_speed * 2 + self.IV_speed + (self.EV_speed/4))*self.level)/100) + 5) * 1

func _calculate_attack():
	var stats_rng_2 = RandomNumberGenerator.new()
	stats_rng_2.randomize()
	IV_attack += stats_rng_2.randi_range(0,32)
	Max_attack = ((((self.base_attack * 2 + self.IV_attack + (self.EV_attack/4))*self.level)/100) + 5) * 1

func _calculate_health_points():
	var stats_rng_1 = RandomNumberGenerator.new()
	stats_rng_1.randomize()
	IV_Health_points += stats_rng_1.randi_range(0,32)
	Max_health_points = ((((self.base_Health_points *2 + self.IV_Health_points + (self.EV_Health_points/4))*self.level)/100 )+ 10 + level) 

func _calculate_defense():
	var stats_rng_3 = RandomNumberGenerator.new()
	stats_rng_3.randomize()
	IV_defense += stats_rng_3.randi_range(0,32)
	Max_defense = ((((self.base_defense * 2 + self.IV_defense + (self.EV_defense/4))*self.level)/100) + 5) * 1

func _calculate_special_attack():
	var stats_rng_4 = RandomNumberGenerator.new()
	stats_rng_4.randomize()
	IV_special_attack += stats_rng_4.randi_range(0,32)
	Max_special_attack = ((((self.base_special_attack * 2 + self.IV_special_attack + (self.EV_special_attack/4))*self.level)/100) + 5) * 1

func _calculate_special_defense():
	var stats_rng_5 = RandomNumberGenerator.new()
	stats_rng_5.randomize()
	IV_special_defense += stats_rng_5.randi_range(0,32)
	Max_special_defense = ((((self.base_special_defense * 2 + self.IV_special_defense + (self.EV_special_defense/4))*self.level)/100) + 5) * 1

func save():
	var save_dict = {
		"Current_health_points": Current_health_points,
		"Current_attack" :  Current_attack,
		"Current_defense" :  Current_defense,
		"Current_special_attack":Current_special_attack,
		"Current_special_defense": Current_special_defense,
		"Current_speed":Current_speed,

		"Max_health_points":Max_health_points,
		"Max_speed":Max_speed,
		"Max_attack":Max_attack,
		"Max_defense" : Max_defense,
		"Max_special_attack":Max_special_attack,
		"Max_special_defense":Max_special_defense,

		"IV_Health_points": IV_Health_points,
		"IV_speed":IV_speed,
		"IV_attack":IV_attack,
		"IV_defense":IV_defense,
		"IV_special_attack":IV_special_attack,
		"IV_special_defense":IV_special_defense,

		"EV_Health_points": EV_Health_points,
		"EV_speed": EV_speed,
		"EV_attack": EV_attack,
		"EV_defense": EV_defense,
		"EV_special_attack": EV_special_attack,
		"EV_special_defense": EV_special_defense,

		"filename" : get_filename(),
		"parent" : get_parent().get_path(),

		"level" : level,
		"experince_gained" : experince_gained,
		"experince_to_next_level" : experince_to_next_level,
		"gender" : gender,

		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,

		"name_changed":name_changed,
		"name":name,
		"added":added,
		"change_path":change_path,
		"change_pc_poke":change_pc_poke,

		"current_stage":current_stage,
		"Name":Name,
		"id":id,
		"Damage_normally_by":Damage_normally_by,
		"Weak_to":Weak_to,
		"Resistant_to":Resistant_to,
		"Immune_to":Immune_to,
		"level_to_next_form":level_to_next_form,
		"gender_ratio":gender_ratio,
		"Type_1":Type_1,
		"Type_2":Type_2,
		"catch_rate":catch_rate,
		"Levelling_rate":Levelling_rate,
		"Min_Hatch_time":Min_Hatch_time,
		"Max_Hatch_time":Max_Hatch_time,
		"egg_groups":egg_groups,
		"base_friend_ship":base_friend_ship,
		"height":height,
		"weight":weight,
		"pokemon_entry":pokemon_entry,
		"abilites":abilites,

		"stats_calculated":stats_calculated,

	}
	return save_dict

func change_parent():
	get_parent().remove_child(self)
	Utils.parent_to_change.add_child(self)
	if Utils.parent_to_change == OpposingTrainerMonsters:
		OpposingTrainerMonsters.pokemon = self

func _check_move_to_learn():
	if self.get_parent() != null:
		if self.get_parent() == OpposingTrainerMonsters:
			if BattleManager.type_of_battle == BattleManager.types_of_battle.Trainer:
				if BattleManager.multi_battle == false:
					var Moves : Array = OpposingTrainerMonsters.active_trainers[0].get_pokemon_moves(self.Name)
					if Moves.size() > 0:
						for i in Moves:
							var Move = i.instance()
							for j in self.get_children():
								if Move.Name == j.Name:
									i._start_learning()
					else:
						for i in range(0,self.get_child_count()):
							self.get_child(i)._start_learning()
			elif BattleManager.type_of_battle ==BattleManager.types_of_battle.Wild: 
				for i in range(0,self.get_child_count()):
					self.get_child(i)._start_learning()
		elif self.get_parent() == PlayerPokemon:
			for i in range(0,self.get_child_count()):
				self.get_child(i)._start_learning()


func learn(move):
	self.Learned_moves.append(move)


func _unlearn(move):
	self.Learned_moves.erase(move)
	move.unlearned = true
	move.learned = false
	move.to_add = false
	move.can_add = false


func _calc_weak_and_res():
	if self.get_parent() == OpposingTrainerMonsters:
		if OpposingTrainerMonsters.pokemon == self:
			if OpposingTrainerMonsters.opposing_pokemon != null:
				self.opposing_pokemon = OpposingTrainerMonsters.opposing_pokemon
				if self.opposing_pokemon != null and PlayerPokemon.current_pokemon != null:
					if self.opposing_pokemon.id == self.id:
						self.Weakness = 1
						self.Resistance = 1
					elif self.opposing_pokemon.id != self.id:
						for i in self.opposing_pokemon.Weak_to.size():
							if self.opposing_pokemon.Weak_to[i] == self.Type_1[0]:
								self.Weakness = 2
								self.Resistance = 2
						for i in self.opposing_pokemon.Resistant_to.size():
							if self.opposing_pokemon.Resistant_to[i] == self.Type_1[0]:
								self.Resistance = 0.5
								self.Weakness = 2
						for i in self.opposing_pokemon.Damage_normally_by.size():
							if self.opposing_pokemon.Damage_normally_by[i] == self.Type_1[0]:
								self.Resistance = 1
								self.Weakness = 1
						for i in self.opposing_pokemon.Immune_to.size():
							if self.opposing_pokemon.Immune_to[i] == self.Type_1[0]:
								self.Resistance = 0
								self.Weakness = 0
			else:
				self.opposing_pokemon = null
	
	elif self.get_parent() == PlayerPokemon:
		if PlayerPokemon.current_pokemon == self:
			if PlayerPokemon.opposing_pokemon != null:
				self.opposing_pokemon = PlayerPokemon.opposing_pokemon
				if self.opposing_pokemon != null and OpposingTrainerMonsters.pokemon != null:
					if self.opposing_pokemon.id == self.id:
						self.Weakness = 1
						self.Resistance = 1
					elif self.opposing_pokemon.id != self.id:
						for i in self.opposing_pokemon.Weak_to.size():
							if self.opposing_pokemon.Weak_to[i] == self.Type_1[0]:
								self.Weakness = 2
								self.Resistance = 2
						for i in self.opposing_pokemon.Resistant_to.size():
							if self.opposing_pokemon.Resistant_to[i] == self.Type_1[0]:
								self.Resistance = 0.5
								self.Weakness = 2
						for i in self.opposing_pokemon.Damage_normally_by.size():
							if self.opposing_pokemon.Damage_normally_by[i] == self.Type_1[0]:
								self.Resistance = 1
								self.Weakness = 1
						for i in self.opposing_pokemon.Immune_to.size():
							if self.opposing_pokemon.Immune_to[i] == self.Type_1[0]:
								self.Resistance = 0
								self.Weakness = 0
		elif PlayerPokemon.current_pokemon != self:
			self.opposing_pokemon = null
	
	
func _physics_process(_delta):


	if is_zero_approx(self.Current_health_points) or self.Current_health_points < 0:
		self.fainted = true
	else:
		self.fainted = false
	
	if fainted == true:
		if exp_given == false:
			print("losing")
			_lose()
			exp_given = true

	if BattleManager.in_battle == true:
		if self.opposing_pokemon != null:
			self.in_battle = true
	else:
		self.in_battle = false

	if self.get_parent() != null:
		self.current_holder = self.get_parent()
	


		if self.get_parent() != null and self.get_parent() == PlayerPokemon:
			if PlayerPokemon.first_pokemon == null and not added:
				PlayerPokemon.first_pokemon = self
				added = true
				change_path = "first_pokemon"
			elif PlayerPokemon.second_pokemon == null and not added:
				PlayerPokemon.second_pokemon = self
				added = true
				change_path = "second_pokemon"
			elif PlayerPokemon.third_pokemon == null and not added:
				PlayerPokemon.third_pokemon = self
				added = true
				change_path = "third_pokemon"
			elif PlayerPokemon.fourth_pokemon == null and not added:
				PlayerPokemon.fourth_pokemon = self
				added = true
				change_path = "fourth_pokemon"
			elif PlayerPokemon.fifth_pokemon == null and not added:
				PlayerPokemon.fifth_pokemon = self
				added = true
				change_path = "fifth_pokemon"
			elif PlayerPokemon.sixth_pokemon == null and not added:
				PlayerPokemon.sixth_pokemon = self
				added = true
				change_path = "sixth_pokemon"
			else:
				if not added:
					PlayerPokemon.pc_pokemon.append(self)
					added = true
					change_pc_poke = "pc_pokemon" + String(Utils.Num_loaded_pokemon)
					change_path = "pc_pokemon" + String(Utils.Num_loaded_pokemon)

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if PlayerPokemon.first_pokemon == self:
			self.change_path = "first_pokemon"
		elif PlayerPokemon.second_pokemon == self:
			self.change_path = "second_pokemon"
		elif PlayerPokemon.third_pokemon == self:
			self.change_path = "third_pokemon"
		elif PlayerPokemon.fourth_pokemon == self:
			self.change_path = "fourth_pokemon"
		elif PlayerPokemon.fifth_pokemon == self:
			self.change_path = "fifth_pokemon"
		elif PlayerPokemon.sixth_pokemon == self:
			self.change_path = "sixth_pokemon"
		else:
			self.change_path = change_pc_poke


#evolving
func evolve():
	if self.level >= self.level_to_next_form and self.next_form != null:
		if self.next_form != null:
			Utils.get_player().set_physics_process(false)
			evolver = self.next_form.instance()
			Utils.Get_Scene_Manager().get_child(9).get_child(0).start_evolutuon(self, self.sprite, self.evolver.sprite)
	else:
		pass

func evolution_value_change():
	if self.next_form != null:
		self.current_stage += 1
		#reassigning the values
		evolver = self.next_form.instance()
		self.id = self.evolver.id
		self.Name = self.evolver.Name
		self.sprite = self.evolver.sprite
		self.next_form = self.evolver.next_form
		self.Type_1 = self.evolver.Type_1
		self.Type_2 = self.evolver.Type_2
		self.Damage_normally_by = self.evolver.Damage_normally_by
		self.Weak_to = self.evolver.Weak_to
		self.Resistant_to = self.evolver.Resistant_to
		self.Immune_to = self.evolver.Immune_to
		self.level_to_next_form = self.evolver.level_to_next_form
		self.abilites = self.evolver.abilites
		self.catch_rate = self.evolver.catch_rate
		self.Levelling_rate = self.evolver.Levelling_rate
		self.Min_Hatch_time = self.evolver.Min_Hatch_time
		self.Max_Hatch_time = self.evolver.Max_Hatch_time
		self.gender_ratio = self.evolver.gender_ratio
		self.egg_groups = self.evolver.egg_groups
		self.base_friend_ship = self.evolver.base_friend_ship
		self.height = self.evolver.height
		self.weight = self.evolver.weight
		self.base_Health_points = self.evolver.base_Health_points
		self.base_attack = self.evolver.base_attack
		self.base_defense = self.evolver.base_defense
		self.base_special_attack = self.evolver.base_special_attack
		self.base_special_defense = self.evolver.base_special_defense
		self.base_speed = self.evolver.base_speed
		self.hp_yield = self.evolver.hp_yield
		self.attack_yield = self.evolver.attack_yield
		self.sp_attack_yield = self.evolver.sp_attack_yield
		self.sp_defense_yield = self.evolver.sp_defense_yield
		self.defense_yield = self.evolver.defense_yield
		self.speed_yield = self.evolver.speed_yield
		self.pokemon_entry = self.evolver.pokemon_entry

	else:
		print("Max staged reached")

signal Enemy_attacked(pokemon,move)

func _wild_battle():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng_move = rng.randi_range(0,(self.Learned_moves.size() -1))

	var return_data = [self,rng_move]
	return return_data

func _wild_battle_attack():
	self.Learned_moves[rng_move]._calculate_damage()

func _trainer_battle():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng_move = rng.randi_range(0,(self.Learned_moves.size() -1))
	emit_signal("Enemy_attacked",self,rng_move)

func _trainer_battle_attack():
	self.Learned_moves[rng_move]._calculate_damage()

func _heal():
	Current_health_points = Max_health_points
	Current_attack = Max_attack
	Current_defense = Max_defense
	Current_special_attack = Max_special_attack
	Current_special_defense = Max_special_defense
	Current_speed = Max_speed
	status_effect = 5
	print(status_effect)
	for i in self.Learned_moves:
		i._heal()
