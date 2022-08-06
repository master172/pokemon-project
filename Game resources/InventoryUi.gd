extends Control

#<item_box>
#<boxes>
onready var item_box = $TextureRect/Item_box
onready var Item_slot = load("res://Game resources/Item_box.tscn")

onready var free_space = $TextureRect/Item_box/Free_space
onready var items = $TextureRect/Item_box/Items
onready var battle_items = $TextureRect/Item_box/Battle_items
onready var medicine = $TextureRect/Item_box/Medicine
onready var tm_hm = $TextureRect/Item_box/Tm_hm
onready var berries = $TextureRect/Item_box/Berries
onready var pokeballs = $TextureRect/Item_box/Pokeballs
onready var key_items = $TextureRect/Item_box/Key_items
#</boxes>

#<grids>
onready var free_space_grid = $TextureRect/Item_box/Free_space/ScrollContainer/Free_space_grid
onready var item_grid = $TextureRect/Item_box/Items/ScrollContainer/Item_grid
onready var battle_grid = $TextureRect/Item_box/Battle_items/ScrollContainer/Battle_grid
onready var medicine_grid = $TextureRect/Item_box/Medicine/ScrollContainer/Medicine_grid
onready var tm_hm_grid = $TextureRect/Item_box/Tm_hm/ScrollContainer/Tm_hm_grid
onready var berries_grid = $TextureRect/Item_box/Berries/ScrollContainer/Berries_grid
onready var poke_ball_grid = $TextureRect/Item_box/Pokeballs/ScrollContainer/poke_ball_grid
onready var key_item_grid = $TextureRect/Item_box/Key_items/ScrollContainer/Key_item_grid

#</grids>

enum pockets {Free_space, Items, Battle_Items, Medicine, Tm_hm, Berries, Pokeballs, Key_items}
var current_pocket = pockets.Free_space
var pocket_var = 0

var pre_item_slot
var current_item_slot
onready var pocket_map : Array = [free_space,items,battle_items,medicine,tm_hm,berries,pokeballs,key_items]

var max_space = 0
#</item_box>

#<poke box slots>
onready var Slot_1 = $TextureRect/Poke_box/GridContainer/Slot_1
onready var Slot_1_sprite = $TextureRect/Poke_box/GridContainer/Slot_1/Sprite/Pokemon

onready var Slot_2 = $TextureRect/Poke_box/GridContainer/Slot_2
onready var Slot_2_sprite = $TextureRect/Poke_box/GridContainer/Slot_2/Sprite/Pokemon

onready var Slot_3 = $TextureRect/Poke_box/GridContainer/Slot_3
onready var Slot_3_sprite = $TextureRect/Poke_box/GridContainer/Slot_3/Sprite/Pokemon

onready var Slot_4 = $TextureRect/Poke_box/GridContainer/Slot_4
onready var Slot_4_sprite = $TextureRect/Poke_box/GridContainer/Slot_4/Sprite/Pokemon

onready var Slot_5 = $TextureRect/Poke_box/GridContainer/Slot_5
onready var Slot_5_sprite = $TextureRect/Poke_box/GridContainer/Slot_5/Sprite/Pokemon

onready var Slot_6 = $TextureRect/Poke_box/GridContainer/Slot_6
onready var Slot_6_sprite = $TextureRect/Poke_box/GridContainer/Slot_6/Sprite/Pokemon

onready var Poke_slots :Array =  [Slot_1,Slot_2,Slot_3,Slot_4,Slot_5,Slot_6]


#</poke box slots>

#<pocket_selection>
onready var Pocket_selector = $TextureRect/Pocket_box/Sprite
onready var Pocket_container = $TextureRect/Pocket_box/Container
#</pocket_selection>


#<selection>

enum states {Poke_selection, Pocket_selection, Dialogue, Item_Selection}
var state = states.Poke_selection

var current_selected = 0
var max_selecctable


var Pokeballs = []
var Key_items = []
var Tm_Hm = []
var Berries = []
var Free_space = []
var Battle_Items = []
var Medicine = []
var Bag_items = []




func _ready():
	state = states.Poke_selection
	
	

	yield(get_tree().create_timer(0.2),"timeout")
	if PlayerPokemon.first_pokemon != null:
		if Slot_1_sprite.texture != PlayerPokemon.first_pokemon.sprite:
			Slot_1_sprite.texture = PlayerPokemon.first_pokemon.sprite
	if PlayerPokemon.second_pokemon != null:
		if Slot_2_sprite.texture != PlayerPokemon.second_pokemon.sprite:
			Slot_2_sprite.texture = PlayerPokemon.second_pokemon.sprite
	if PlayerPokemon.third_pokemon != null:
		if Slot_3_sprite.texture != PlayerPokemon.third_pokemon.sprite:
			Slot_3_sprite.texture = PlayerPokemon.third_pokemon.sprite
	if PlayerPokemon.fourth_pokemon != null:
		if Slot_4_sprite.texture != PlayerPokemon.fourth_pokemon.sprite:
			Slot_4_sprite.texture = PlayerPokemon.fourth_pokemon.sprite
	if PlayerPokemon.fifth_pokemon != null:
		if Slot_5_sprite.texture != PlayerPokemon.fifth_pokemon.sprite:
			Slot_5_sprite.texture = PlayerPokemon. fifth_pokemon.sprite
	if PlayerPokemon.sixth_pokemon != null:
		if Slot_6_sprite.texture != PlayerPokemon.sixth_pokemon.sprite:
			Slot_6_sprite.texture = PlayerPokemon.sixth_pokemon.sprite
	
	Pokeballs = PokeHelper.Pokeballs
	Key_items = PokeHelper.Key_items
	Tm_Hm = PokeHelper.Tm_Hm
	Berries = PokeHelper.Berries
	Free_space = PokeHelper.Free_space
	Battle_Items = PokeHelper.Battle_Items
	Medicine = PokeHelper.Medicine
	Bag_items = PokeHelper.items
	
	
	for _i in range(0,Bag_items.size()):
		var item_slot = Item_slot.instance()
		item_grid.add_child(item_slot)
	
	for _i in range(0,Medicine.size()):
		var item_slot = Item_slot.instance()
		medicine_grid.add_child(item_slot)
	
	for _i in range(0,Battle_Items.size()):
		var item_slot = Item_slot.instance()
		battle_grid.add_child(item_slot)
	
	for _i in range(0,Tm_Hm.size()):
		var item_slot = Item_slot.instance()
		tm_hm_grid.add_child(item_slot)
	
	for _i in range(0,Key_items.size()):
		var item_slot = Item_slot.instance()
		key_item_grid.add_child(item_slot)
	
	for _i in range(0,Free_space.size()):
		var item_slot = Item_slot.instance()
		free_space_grid.add_child(item_slot)
	
	for _i in range(0,Berries.size()):
		var item_slot = Item_slot.instance()
		berries_grid.add_child(item_slot)
	
	for _i in range(0,Pokeballs.size()):
		var item_slot = Item_slot.instance()
		poke_ball_grid.add_child(item_slot)

func _input(event):
	if state == states.Pocket_selection:
		if event.is_action_pressed("W"):
			state = states.Item_Selection
			current_selected = 0
			
		if event.is_action_pressed("A"):
			for i in range(0,Pocket_container.get_child_count()):
				Pocket_container.get_child(i).rect_position.x += 14
			if pocket_var > 0:
				pocket_var -= 1
			else:
				pocket_var = max_selecctable
		if event.is_action_pressed("S"):
			state = states.Poke_selection
			current_selected = 5
			max_selecctable = 5
		if event.is_action_pressed("D"):

			for i in range(0,Pocket_container.get_child_count()):
				Pocket_container.get_child(i).rect_position.x -= 14
			
			if pocket_var < max_selecctable:
				pocket_var += 1
			else:
				pocket_var = 0
	
	elif state == states.Poke_selection:
		if event.is_action_pressed("W"):
			if current_selected < max_selecctable:
				current_selected += 1
			elif current_selected == max_selecctable:
				state = states.Pocket_selection
				current_selected = 0
		
		elif event.is_action_pressed("S"):
			if current_selected > 0:
				current_selected -= 1
			elif current_selected == 0:
				state = states.Item_Selection	
				current_selected = 0
		

		if event.is_action_pressed("D"):
			if current_selected < max_selecctable:
				current_selected += 1
			elif current_selected == max_selecctable:
				state = states.Pocket_selection
				current_selected = 0
		
		elif event.is_action_pressed("A"):
			if current_selected > 0:
				current_selected -= 1
			elif current_selected == 0:
				state = states.Item_Selection	
				current_selected = 0
	
	elif state == states.Dialogue:
		pass
	
	elif state == states.Item_Selection:
		if event.is_action_pressed("W"):
			if current_selected < max_selecctable:
				current_selected += 1
			elif current_selected == max_selecctable:
				state = states.Poke_selection
				current_selected = 0
			if pre_item_slot != null:
				pre_item_slot.frame = 0
		
		elif event.is_action_pressed("S"):
			if current_selected > 0:
				current_selected -= 1
			elif current_selected == 0:
				state = states.Pocket_selection	
				current_selected = 0
			if pre_item_slot != null:
				pre_item_slot.frame = 0

		if event.is_action_pressed("D"):
			if current_selected < max_selecctable:
				current_selected += 1
			elif current_selected == max_selecctable:
				state = states.Poke_selection
				current_selected = 0
			if pre_item_slot != null:
				pre_item_slot.frame = 0
		elif event.is_action_pressed("A"):
			if current_selected > 0:
				current_selected -= 1
			elif current_selected == 0:
				state = states.Pocket_selection	
				current_selected = 0
			if pre_item_slot != null:
				pre_item_slot.frame = 0
	


func _physics_process(_delta):
	Pokeballs = PokeHelper.Pokeballs
	Key_items = PokeHelper.Key_items
	Tm_Hm = PokeHelper.Tm_Hm
	Berries = PokeHelper.Berries
	Free_space = PokeHelper.Free_space
	Battle_Items = PokeHelper.Battle_Items
	Medicine = PokeHelper.Medicine
	Bag_items = PokeHelper.items
	
	
	#states
	
	#Poke_selection
	if state == states.Poke_selection:
		max_selecctable = 5
		Pocket_selector.frame = 0
		for i in range(0,Poke_slots.size()):
			if i == current_selected:
				Poke_slots[i].active = true
			else:
				Poke_slots[i].active = false
	
	#pocket_selection
	elif state == states.Pocket_selection:
		for i in range(0,Poke_slots.size()):
			Poke_slots[i].active = false
		
		match pocket_var:
			0:
				current_pocket = pockets.Free_space
			1:
				current_pocket = pockets.Items
			2:
				current_pocket = pockets.Battle_Items
			3:
				current_pocket = pockets.Medicine
			4:
				current_pocket = pockets.Tm_hm
			5:
				current_pocket = pockets.Berries
			6:
				current_pocket = pockets.Pokeballs
			7:
				current_pocket = pockets.Key_items
		
		if current_pocket == pockets.Free_space:
			free_space.active = true
			max_space = Free_space.size() - 1
		else:
			free_space.active = false
		
		if current_pocket == pockets.Items:
			items.active = true
			max_space = Bag_items.size() - 1
		else:
			items.active = false
		
		if current_pocket == pockets.Battle_Items:
			battle_items.active = true
			max_space = Battle_Items.size() - 1
		else:
			battle_items.active = false
		
		if current_pocket == pockets.Medicine:
			medicine.active = true
			max_space = Medicine.size() - 1
		else:
			medicine.active = false
		
		
		if current_pocket == pockets.Tm_hm:
			tm_hm.active = true
			max_space = Tm_Hm.size() - 1
		else:
			tm_hm.active = false
		
		
		if current_pocket == pockets.Berries:
			berries.active = true
			max_space = Berries.size() - 1
		else:
			berries.active = false
		
		if current_pocket == pockets.Pokeballs:
			pokeballs.active = true
			max_space = Pokeballs.size() - 1
		else:
			pokeballs.active = false
		
		
		if current_pocket == pockets.Key_items:
			key_items.active = true
			max_space = Key_items.size() - 1
		else:
			key_items.active = false
		
		max_selecctable = 7
		
		Pocket_selector.frame = 1
	
	#dialogue
	elif state == states.Dialogue:
		for i in range(0,Poke_slots.size()):
			Poke_slots[i].active = false
		Pocket_selector.frame = 0
	
	#Items
	elif state == states.Item_Selection:
		
		max_selecctable = max_space
		for i in range(0,Poke_slots.size()):
			Poke_slots[i].active = false
		Pocket_selector.frame = 0
		
		pre_item_slot = pocket_map[current_pocket].get_child(0).get_child(0).get_child(current_selected).get_child(0)
		
		pocket_map[current_pocket].get_child(0).get_child(0).get_child(current_selected).get_child(0).frame = 1

		current_item_slot = pocket_map[current_pocket].get_child(0).get_child(0).get_child(current_selected).get_child(0)


