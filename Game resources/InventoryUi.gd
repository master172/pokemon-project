extends Control

var controller

#<Dialogue>
onready var dialogue_container = $Dialogue_controller
onready var Item_displayer = $Dialogue_controller/HBoxContainer/Item_displayer
onready var Item_label = $Dialogue_controller/HBoxContainer/Label

var current_to_display_text = ""

#<preset_dialogues>
var Not_now = "Professors words echoed:, Ash there is a time for everythin but not now"
#</Dialogue>

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

#<dependencies>
const cont_box = preload("res://Game resources/Cont_box.tscn")
var Cont_box
#</dependencies>

enum states {Poke_selection, Pocket_selection, Dialogue, Item_Selection,Cont_box,Item_poke_selection,Scene_switched}
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

var current_item
var current_pokemon

func _set_current_selected():
	
	if state == states.Poke_selection or state == states.Item_poke_selection:
		if current_selected == 0:
			current_pokemon = PlayerPokemon.first_pokemon
		elif current_selected == 1:
			current_pokemon = PlayerPokemon.second_pokemon
		elif current_selected == 2:
			current_pokemon = PlayerPokemon.third_pokemon
		elif current_selected == 3:
			current_pokemon = PlayerPokemon.fourth_pokemon
		elif current_selected == 4:
			current_pokemon = PlayerPokemon. fifth_pokemon
		elif current_selected == 5:
			current_pokemon = PlayerPokemon.sixth_pokemon
		else:
			current_pokemon = current_pokemon
	else:
		current_pokemon = current_pokemon
	
	if state == states.Item_Selection:
		if current_pocket == 0 and PokeHelper.Free_space.size() > 0:
			current_item = PokeHelper.Free_space[current_selected]

		elif current_pocket == 1 and PokeHelper.items.size() > 0:
			current_item = PokeHelper.items[current_selected]

		elif current_pocket == 2 and PokeHelper.Battle_Items.size() > 0:
			current_item = PokeHelper.Battle_Items[current_selected]

		elif current_pocket == 3 and PokeHelper.Medicine.size() > 0:
			current_item = PokeHelper.Medicine[current_selected]

		elif current_pocket == 4 and PokeHelper.Tm_Hm.size() > 0:
			current_item = PokeHelper.Tm_Hm[current_selected]

		elif current_pocket == 5 and PokeHelper.Berries.size() > 0:
			current_item = PokeHelper.Berries[current_selected]

		elif current_pocket == 6 and PokeHelper.Pokeballs.size() > 0:
			current_item = PokeHelper.Pokeballs[current_selected]

		elif current_pocket == 7 and PokeHelper.Key_items.size() > 0:
			current_item = PokeHelper.Key_items[current_selected]
		else:
			current_item = current_item
	else:
		current_item = current_item


func _ready():
	state = states.Poke_selection
	

	#adding the pokemon sprites in pokemon slots

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
	
	#finish setting the pokemon Sprite

	#setting the pocket arrays
	
	Pokeballs = PokeHelper.Pokeballs
	Key_items = PokeHelper.Key_items
	Tm_Hm = PokeHelper.Tm_Hm
	Berries = PokeHelper.Berries
	Free_space = PokeHelper.Free_space
	Battle_Items = PokeHelper.Battle_Items
	Medicine = PokeHelper.Medicine
	Bag_items = PokeHelper.items
	
	
	#adding the Item_slots
	for i in range(0,Bag_items.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Bag_items[i]
		item_grid.add_child(item_slot)
	
	for i in range(0,Medicine.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Medicine[i]
		medicine_grid.add_child(item_slot)
	
	for i in range(0,Battle_Items.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Battle_Items[i]
		battle_grid.add_child(item_slot)
	
	for i in range(0,Tm_Hm.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Tm_Hm[i]
		tm_hm_grid.add_child(item_slot)
	
	for i in range(0,Key_items.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Key_items[i]
		key_item_grid.add_child(item_slot)
	
	for i in range(0,Free_space.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Free_space[i]
		free_space_grid.add_child(item_slot)
	
	for i in range(0,Berries.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Berries[i]
		berries_grid.add_child(item_slot)
	
	for i in range(0,Pokeballs.size()):
		var item_slot = Item_slot.instance()
		item_slot.item = PokeHelper.Pokeballs[i]
		poke_ball_grid.add_child(item_slot)
	
	#finish adding the item slots

#resseting the state after closing the controller box
func _reset(value):
	yield(get_tree().create_timer(0.01),"timeout")
	if value == true:
		state = states.Item_Selection
	else:
		state = states.Item_poke_selection
		current_selected = 0

func _input(event):
	
	


	if is_instance_valid(Cont_box):
		state = states.Cont_box
	else:
		state = state
	


	if state != states.Cont_box:
		if event.is_action_pressed("accept"):
			if state == states.Item_Selection:
				Cont_box = cont_box.instance()
				Cont_box.controller = self
				if current_pocket == 0 and PokeHelper.Free_space.size() > 0:
					Cont_box.current_item = PokeHelper.Free_space[current_selected]

				elif current_pocket == 1 and PokeHelper.items.size() > 0:
					Cont_box.current_item = PokeHelper.items[current_selected]

				elif current_pocket == 2 and PokeHelper.Battle_Items.size() > 0:
					Cont_box.current_item = PokeHelper.Battle_Items[current_selected]

				elif current_pocket == 3 and PokeHelper.Medicine.size() > 0:
					Cont_box.current_item = PokeHelper.Medicine[current_selected]

				elif current_pocket == 4 and PokeHelper.Tm_Hm.size() > 0:
					Cont_box.current_item = PokeHelper.Tm_Hm[current_selected]

				elif current_pocket == 5 and PokeHelper.Berries.size() > 0:
					Cont_box.current_item = PokeHelper.Berries[current_selected]

				elif current_pocket == 6 and PokeHelper.Pokeballs.size() > 0:
					Cont_box.current_item = PokeHelper.Pokeballs[current_selected]

				elif current_pocket == 7 and PokeHelper.Key_items.size() > 0:
					Cont_box.current_item = PokeHelper.Key_items[current_selected]
	
				self.add_child(Cont_box)
				
				self.state = states.Cont_box
				
		if state == states.Pocket_selection:
			if event.is_action_pressed("decline"):
				if self.controller != null:
					if self.controller.Name == "Pokemon_scene_stage":
						self.controller.ui_state = self.controller.Ui_state.Main
						queue_free()
					elif self.controller.Name == "Menu":
						_bag_kill()
			if event.is_action_pressed("W"):
				current_to_display_text = ""
				if current_pocket != null:
					if current_pocket == 0 and PokeHelper.Free_space.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 1 and PokeHelper.items.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 2 and PokeHelper.Battle_Items.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 3 and PokeHelper.Medicine.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 4 and PokeHelper.Tm_Hm.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 5 and PokeHelper.Berries.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 6 and PokeHelper.Pokeballs.size() > 0:
						state = states.Item_Selection
						current_selected = 0

					elif current_pocket == 7 and PokeHelper.Key_items.size() > 0:
						state = states.Item_Selection
						current_selected = 0
						
					else:
						state = states.Poke_selection
						current_selected = 0


				
			if event.is_action_pressed("A"):
				current_to_display_text = ""
				for i in range(0,Pocket_container.get_child_count()):
					Pocket_container.get_child(i).rect_position.x += 14
				if pocket_var > 0:
					pocket_var -= 1
				else:
					pocket_var = max_selecctable
			if event.is_action_pressed("S"):
				current_to_display_text = ""
				state = states.Poke_selection
				current_selected = 5
				max_selecctable = 5
			if event.is_action_pressed("D"):
				current_to_display_text = ""

				for i in range(0,Pocket_container.get_child_count()):
					Pocket_container.get_child(i).rect_position.x -= 14
				
				if pocket_var < max_selecctable:
					pocket_var += 1
				else:
					pocket_var = 0
		
		elif state == states.Poke_selection:
			if event.is_action_pressed("decline"):
				if event.is_action_pressed("decline"):
					if self.controller != null:
						if self.controller.Name == "Pokemon_scene_stage":
							self.controller.ui_state = self.controller.Ui_state.Main
							queue_free()
						elif self.controller.Name == "Menu":
							_bag_kill()
			if event.is_action_pressed("W"):
				current_to_display_text = ""
				if current_selected < max_selecctable:
					current_selected += 1
				elif current_selected == max_selecctable:
					state = states.Pocket_selection
					current_selected = 0
			
			elif event.is_action_pressed("S"):
				current_to_display_text = ""
				if current_selected > 0:
					current_selected -= 1
				elif current_selected == 0:
					if current_pocket != null:
						if current_pocket == 0 and PokeHelper.Free_space.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 1 and PokeHelper.items.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 2 and PokeHelper.Battle_Items.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 3 and PokeHelper.Medicine.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 4 and PokeHelper.Tm_Hm.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 5 and PokeHelper.Berries.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 6 and PokeHelper.Pokeballs.size() > 0:
							state = states.Item_Selection
							current_selected = 0
	
						elif current_pocket == 7 and PokeHelper.Key_items.size() > 0:
							state = states.Item_Selection
							current_selected = 0
							
						else:
							state = states.Pocket_selection
							current_selected = 0
			

			if event.is_action_pressed("D"):
				current_to_display_text = ""
				if current_selected < max_selecctable:
					current_selected += 1
				elif current_selected == max_selecctable:
					state = states.Pocket_selection
					current_selected = 0
			
			elif event.is_action_pressed("A"):
				current_to_display_text = ""
				if current_selected > 0:
					current_selected -= 1
				elif current_selected == 0:
					state = states.Item_Selection	
					current_selected = 0
		
		elif state == states.Dialogue:
			pass
		
		elif state == states.Item_Selection:
			if event.is_action_pressed("decline"):
				if self.controller != null:
					if self.controller.Name == "Pokemon_scene_stage":
						self.controller.ui_state = self.controller.Ui_state.Main
						queue_free()
			if event.is_action_pressed("W"):
				current_to_display_text = ""
				if current_selected < max_selecctable:
					current_selected += 1
				elif current_selected == max_selecctable:
					state = states.Poke_selection
					current_selected = 0
				if pre_item_slot != null:
					pre_item_slot.frame = 0
			
			elif event.is_action_pressed("S"):
				current_to_display_text = ""
				if current_selected > 0:
					current_selected -= 1
				elif current_selected == 0:
					state = states.Pocket_selection	
					current_selected = 0
				if pre_item_slot != null:
					pre_item_slot.frame = 0

			if event.is_action_pressed("D"):
				current_to_display_text = ""
				if current_selected < max_selecctable:
					current_selected += 1
				elif current_selected == max_selecctable:
					state = states.Poke_selection
					current_selected = 0
				if pre_item_slot != null:
					pre_item_slot.frame = 0
			elif event.is_action_pressed("A"):
				current_to_display_text = ""
				if current_selected > 0:
					current_selected -= 1
				elif current_selected == 0:
					state = states.Pocket_selection	
					current_selected = 0
				if pre_item_slot != null:
					pre_item_slot.frame = 0
		

		elif state == states.Item_poke_selection:
			if event.is_action_pressed("decline"):
				state = states.Item_Selection
				current_selected = 0
			if event.is_action_pressed("accept"):
				if current_item != null and current_pokemon != null:
					current_item._use(current_pokemon)
					if current_item.No_effect == true:
						current_to_display_text = current_item.No_effect_text
					state = states.Item_Selection
					current_selected = 0
					
			if event.is_action_pressed("W"):
				current_to_display_text = ""
				if current_selected < max_selecctable:
					current_selected += 1
				else:
					current_selected = 0
			elif event.is_action_pressed("D"):
				current_to_display_text = ""
				if current_selected < max_selecctable:
					current_selected += 1
				else:
					current_selected = 0
			elif event.is_action_pressed("S"):
				current_to_display_text = ""
				if current_selected > 0:
					current_selected -= 1
				else:
					current_selected = max_selecctable
			elif event.is_action_pressed("A"):
				current_to_display_text = ""
				if current_selected > 0:
					current_selected -= 1
				else:
					current_selected = max_selecctable



func _physics_process(_delta):
	_kill()

	_set_current_selected()

	if current_item != null:
		if current_item.has_meta("_useable"):
			pass
		else:
			if state == states.Item_Selection and current_to_display_text == "":
				Item_displayer.texture = current_item.sprite
				Item_label.text = current_item.Description
			elif state == states.Item_Selection and current_to_display_text != "":
				Item_displayer.texture = current_item.sprite
				Item_label.text = current_to_display_text
			elif state == states.Cont_box or state == states.Item_poke_selection:
				Item_displayer.texture = current_item.sprite
				Item_label.text = current_item.current_text
			else:
				Item_displayer.texture = null
				Item_label.text = ""
	
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
	
	#Item_poke_selection
	elif state == states.Item_poke_selection:
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

func _kill():
	if PokeHelper.Pokemon_scene_done == true:
		if self.controller != null:
			if self.controller.Name == "Pokemon_scene_stage":
				self.controller.ui_state = self.controller.Ui_state.Main
				PokeHelper.Pokemon_scene_done = false
				queue_free()


func _bag_kill():
	if self.controller != null:
		if self.controller.Name == "Menu":
			Utils.Get_Scene_Manager().transition_exit_bag_scene()

