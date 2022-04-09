extends Node2D
class_name Pokemon

var exp_given :bool = false

var exp_gainied : float = 0

export(float) var base_experience_yeild

var change_path

var change_pc_poke

var added:bool
var name_changed :bool = false

var in_battle = false

export(Texture) var sprite 

export(String) var Name = ""
export(int) var id =""

export(int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Type_1

export(int,"None","Normal","Fire","Electric","Flying","Ground"\
,"Bug","Psychic","Dragon","Steel","Grass","Water","Fighting"\
,"Poison","Rock","Ice","Ghost","Dark","Fairy") var Type_2


export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Damage_normally_by = null

export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Weak_to = null

export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Resistant_to = null

export(Array,int,"None","Normal","Fire","Electric","Flying","Ground","Bug","Psychic","Dragon","Steel","Grass","Water","Fighting","Poison","Rock","Ice","Ghost","Dark","Fairy") var Immune_to = null


export(Array,Resource) var abilites 

export(Array,Resource) var Learned_moves

export(Array,Resource) var Moves

export(float) var catch_rate = ""

export(String,"Fast","Slow","Medium_slow","Medium_fast","Erratic","Fluctuating") var Levelling_rate 

export(int) var Min_Hatch_time =""
export(int) var Max_Hatch_time =""

export(String,"50.0%_male","25.0%_male","0%_male","100%_male") var gender_ratio

export(int,FLAGS,"Monster","Human-Like","Water 1","Water 3","Bug","MineralFlying","Amorphous","Field","Water 2","Fairy","Ditto","Grass","Dragon","No Eggs Discovered","Gender unknown") var egg_groups

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


var IV_Health_points = 0
var IV_attack = 0
var IV_special_attack = 0
var IV_defense = 0
var IV_special_defense = 0
var IV_speed = 0


var EV_Health_points = 0
var EV_attack = 0
var EV_special_attack = 0
var EV_defense = 0
var EV_special_defense = 0
var EV_speed = 0

export(int)var hp_yield 
export(int)var attack_yield 
export(int)var defense_yield 
export(int)var speed_yield
export(int)var sp_attack_yield
export(int)var sp_defnse_yield

export(String,MULTILINE) var pokemon_entry 

export(PackedScene) var next_form

var can_battle :bool = false
var fainted = false

var Weakness : float
var Resistance : float

var gender

var level : int = 0
var experince_gained :int = 0
var experince_to_next_level :float = 0 
var max_level:int = 100

var opposing_pokemon

var current_holder

func _calculate_exp_poits_to_give():
	var opposition_level
	var battle_type
	var targets
	var win_type
	var turns
	turns = BattleManager.turns
	if BattleManager.catched == true and BattleManager.fainted == false:
		win_type = 1
	elif BattleManager.catched == false and BattleManager.fainted == true:
		win_type = 2
	if self.get_parent() == OpposingTrainerMonsters:
		targets = PlayerPokemon.targets
	if self.opposing_pokemon != null:
		opposition_level = self.opposing_pokemon.level
	else:
		opposition_level = 0 
	if BattleManager.type_of_battle == BattleManager.types_of_battle.Wild:
		battle_type = 1
	else:
		battle_type = 2
	exp_gainied = 1000
	if exp_gainied < 0:
		exp_gainied = exp_gainied*-1
	else:	
		exp_gainied = exp_gainied

func _lose():
	_calculate_exp_poits_to_give()
	if self.opposing_pokemon != null:
		self.opposing_pokemon.experince_gained += exp_gainied
		self.opposing_pokemon._update_level()

func _level_up():
	_update_level()
	_calculate_stats()

func _ready():		
	if name_changed == false:
		self.name = "Pokemon_" + String(Utils.Num_loaded_pokemon) + "_" + name
		Utils.Num_loaded_pokemon += 1
		name_changed = true
	
	
	yield(get_tree().create_timer(0.2),"timeout")

	if added == true:
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
		else:
			PlayerPokemon.pc_pokemon.append(self)

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
	if experince_to_next_level >= experince_to_next_level:
		_update_level()

func _update_level():
	if experince_to_next_level != 0:
		if experince_gained >= experince_to_next_level:
			level += 1
			_calculate_experience()

func _calculate_stats():
	var stats_calculated : bool = false
	if stats_calculated == false:
		_calculate_health_points()
		_calculate_attack()
		_calculate_defense()
		_calculate_special_attack()
		_calculate_special_defense()
		_calculate_speed()
		stats_calculated = true
		return 

func _calculate_speed():
	var stats_rng_6 = RandomNumberGenerator.new()
	stats_rng_6.randomize()
	EV_attack += stats_rng_6.randi_range(0,32)
	Current_speed += base_speed + EV_speed + IV_speed
	Max_speed = Current_speed

func _calculate_attack():
	var stats_rng_2 = RandomNumberGenerator.new()
	stats_rng_2.randomize()
	EV_attack += stats_rng_2.randi_range(0,32)
	Current_attack += base_attack + EV_attack + IV_attack
	Max_attack = Current_attack

func _calculate_health_points():
	var stats_rng_1 = RandomNumberGenerator.new()
	stats_rng_1.randomize()
	EV_Health_points += stats_rng_1.randi_range(0,32)
	Current_health_points += base_Health_points + EV_Health_points + IV_Health_points
	Max_health_points = Current_health_points

func _calculate_defense():
	var stats_rng_3 = RandomNumberGenerator.new()
	stats_rng_3.randomize()
	EV_defense += stats_rng_3.randi_range(0,32)
	Current_defense += base_defense + EV_defense + IV_defense
	Max_defense = Current_defense

func _calculate_special_attack():
	var stats_rng_4 = RandomNumberGenerator.new()
	stats_rng_4.randomize()
	EV_special_attack += stats_rng_4.randi_range(0,32)
	Current_special_attack += base_special_attack + EV_special_attack + IV_special_attack
	Max_special_attack = Current_special_attack

func _calculate_special_defense():
	var stats_rng_5 = RandomNumberGenerator.new()
	stats_rng_5.randomize()
	EV_special_defense += stats_rng_5.randi_range(0,32)
	Current_special_defense += base_special_defense + EV_special_defense + IV_special_defense
	Max_special_defense = Current_special_defense

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

		"filename" : get_filename(),
		"parent" : get_parent().get_path(),

		"level" : level,
		"Moves":Moves,
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
	}
	return save_dict

func change_parent():
	get_parent().remove_child(self)
	Utils.parent_to_change.add_child(self)

func learn(move):
	self.Learned_moves.append(move)

func _unlearn(move):
	move.learned = false
	move.to_add = false

func _physics_process(_delta):

	if self.Current_health_points <= 0:
		self.fainted = true
	else:
		self.fainted = false
	
	if fainted:
		if not exp_given:
			_lose()
			exp_given = true

	if BattleManager.in_battle == true:
		if self.opposing_pokemon != null:
			self.in_battle = true
	else:
		self.in_battle = false

	if self.get_parent() != null:
		self.current_holder = self.get_parent()
	
	if self.get_parent() == OpposingTrainerMonsters:
		OpposingTrainerMonsters.pokemon = self
		if OpposingTrainerMonsters.pokemon == self:
			if OpposingTrainerMonsters.opposing_pokemon != null:
				self.opposing_pokemon = OpposingTrainerMonsters.opposing_pokemon
				if self.opposing_pokemon != null and PlayerPokemon.current_pokemon != null:
					if self.opposing_pokemon.Weak_to.has(self.Type_1):
						self.Resistance = 2
						self.Weakness = 2
					elif self.opposing_pokemon.Resistant_to.has(self.Type_1):
						self.Resistance = 0.5
						self.Weakness = 2
					elif self.opposing_pokemon.Damage_normally_by.has(self.Type_1):
						self.Resistance = 1
						self.Weakness = 1
					elif self.opposing_pokemon.Immune_to.has(self.Type_1):
						self.Resistance = 0
						self.Weakness = 0
			else:
				self.opposing_pokemon = null
	
	elif self.get_parent() == PlayerPokemon:
		if PlayerPokemon.current_pokemon == self:
			if PlayerPokemon.opposing_pokemon != null:
				self.opposing_pokemon = PlayerPokemon.opposing_pokemon
				if self.opposing_pokemon != null and OpposingTrainerMonsters.pokemon != null:
					if self.opposing_pokemon.Weak_to.has(self.Type_1):
						self.Resistance = 2
						self.Weakness = 2
					elif self.opposing_pokemon.Resistant_to.has(self.Type_1):
						self.Resistance = 0.5
						self.Weakness = 2
					elif self.opposing_pokemon.Damage_normally_by.has(self.Type_1):
						self.Resistance = 1
						self.Weakness = 1
					elif self.opposing_pokemon.Immune_to.has(self.Type_1):
						self.Resistance = 0
						self.Weakness = 0
			else:
				self.opposing_pokemon = null

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
