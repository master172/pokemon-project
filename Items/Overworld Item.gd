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

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	if self.used == false:
		pass
	elif self.used == true:
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
				PokeHelper.Free_space.append(self.holding_item.instance())
				print("Free_space")
			elif self.Holding_item.type == "Items":
				PokeHelper.Items.append(self.holding_item.instance())
				print("Items")
			elif self.Holding_item.type == "Battle_Items":
				PokeHelper.Battle_Items.append(self.holding_item.instance())
				print("Battle Items")
			elif self.Holding_item.type == "Medicine":
				PokeHelper.Medicine.append(self.holding_item.instance())
				print("Medicine")
			elif self.Holding_item.type == "Tm_Hm":
				PokeHelper.Tm_Hm.append(self.holding_item.instance())
				print("Tm Hm")
			elif self.Holding_item.type == "Berries":
				PokeHelper.Berries.append(self.holding_item.instance())
				print("Berries")
			elif self.Holding_item.type == "Pokeballs":
				PokeHelper.Pokeballs.append(self.holding_item.instance())
				print("Pokeballs")
			elif self.Holding_item.type == "Key_items":
				PokeHelper.key_items.append(self.holding_item.instance())
				print("Key Items")
			self.visible = false
			$CollisionShape2D.disabled = true
