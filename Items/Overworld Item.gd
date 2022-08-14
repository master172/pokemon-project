extends StaticBody2D

var player

var talked = false
const Dialog = preload("res://UI UX/Dialogue_bar.tscn")

export(Resource) var holding_item


onready var Holding_item = holding_item.instance()
onready var first_dialog :Array = ["Ash found a " + self.Holding_item.Name,"do you want to pick the "+ self.Holding_item.Name,1,2,0]


onready var question :Array = [["yes","Ash picked up the " +self.Holding_item.Name,"Ash kept the " + self.Holding_item.Name + " in the " + self.Holding_item.type + " Pocket",1],["no","Ash left the " + self.Holding_item.Name ,1]]

onready var first_functions :Array = ["Register",[null]]


var dialog = Dialog.instance()

var set_choice

var used = false

func _apply_data():
	if self.used == true:
		self.visible = false
		$CollisionShape2D.disabled = true




func _Start_dialog():
	
	if question != [["yes","Ash picked up the " +self.Holding_item.Name,"Ash kept the " + self.Holding_item.Name + " in the " + self.Holding_item.type + " Pocket",1],["no","Ash left the " + self.Holding_item.Name ,1]]:
		print("changed")

	if dialog != null:
		dialog = dialog
	else:
		dialog = Dialog.instance()
	
	dialog.text_to_diaplay = first_dialog
	dialog.choices = question
	dialog.functions = first_functions
	Utils.get_dialog_layer().add_child(dialog)

		
	dialog.connect("Dialog_ended",self,"_finish_dialog")
	dialog.connect("_function",self,"_register",[dialog.functions])
	dialog.connect("_choice_number",self,"_set_choice",[dialog.selected_choice])

func save():
	var save_dict = {
		"used":used,
		"pos_x" : position.x,
		"pos_y" : position.y,
	}
	return save_dict

func _finish_dialog():
	if player != null:
		yield(get_tree().create_timer(0.2),"timeout")
		player.interacting = false
		player.is_talking = false
		player = null
	dialog = null

func _set_choice(choice,_choice_extra):
	if choice == 0:
		set_choice = "yes"
	elif choice == 1:
		set_choice = "no"

func _register(function_name,_function_params):
	if set_choice == "yes":
		if function_name[0] == "Register" and _function_params[1][0] == null:
			self.Holding_item._register()
			self.used = true
			if self.Holding_item.type == "Free_space":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Free_space.size() != 0:
					for i in range(0,PokeHelper.Free_space.size()):
						if PokeHelper.Free_space[i].id == _Item_to_add.id:
							PokeHelper.Free_space[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Free_space")
			elif self.Holding_item.type == "Items":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Items.size() != 0:
					for i in range(0,PokeHelper.Items.size()):
						if PokeHelper.Items[i].id == _Item_to_add.id:
							PokeHelper.Items[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Items")
			elif self.Holding_item.type == "Battle_Items":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Battle_Items.size() != 0:
					for i in range(0,PokeHelper.Battle_Items.size()):
						if PokeHelper.Battle_Items[i].id == _Item_to_add.id:
							PokeHelper.Battle_Items[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Battle Items")
			elif self.Holding_item.type == "Medicine":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Medicine.size() != 0:
					for i in range(0,PokeHelper.Medicine.size()):
						if PokeHelper.Medicine[i].id == _Item_to_add.id:
							PokeHelper.Medicine[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Medicine")
			elif self.Holding_item.type == "Tm_Hm":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Tm_Hm.size() != 0:
					for i in range(0,PokeHelper.Tm_Hm.size()):
						if PokeHelper.Tm_Hm[i].id == _Item_to_add.id:
							PokeHelper.Tm_Hm[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Tm Hm")
			elif self.Holding_item.type == "Berries":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Berries.size() != 0:
					for i in range(0,PokeHelper.Berries.size()):
						if PokeHelper.Berries[i].id == _Item_to_add.id:
							PokeHelper.Berries[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Berries")
			elif self.Holding_item.type == "Pokeballs":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Pokeballs.size() != 0:
					for i in range(0,PokeHelper.Pokeballs.size()):
						if PokeHelper.Pokeballs[i].id == _Item_to_add.id:
							PokeHelper.Pokeballs[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Pokeballs")
			elif self.Holding_item.type == "Key_items":
				var _Item_to_add = self.holding_item.instance()
				_Item_to_add.count = int(1)
				if PokeHelper.Key_items.size() != 0:
					for i in range(0,PokeHelper.Key_items.size()):
						if PokeHelper.Key_items[i].id == _Item_to_add.id:
							PokeHelper.Key_items[i].count += 1
						else:
							PokeHelper.add_child(_Item_to_add)
				else:
					PokeHelper.add_child(_Item_to_add)
				print("Key Items")
			self.visible = false
			$CollisionShape2D.disabled = true
