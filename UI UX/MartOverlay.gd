extends CanvasLayer

var items = []
var holder

var Current_state = States.Sell 

var current_seleceted = 0
onready var max_selected 
enum States {Sell}

const ItemDropout = preload("res://libraries/ListDropout.tscn")
const DialogBar = preload("res://UI UX/Dialogue_bar.tscn")

var first_dialog = ["please confirm that you would like to buy it",1,0]
var options = [["buy",1],["sell",1],["cancel",1]]

signal start
signal chosen

var buying_item_quantity = 1

var buying = false

var holding_item


var Holding_item

func _ready():
	_decide_update_type()

func _decide_update_type():
	if Current_state == States.Sell:
		_update_buy()

func _update_buy():
	for i in items:
		var listItem = ItemDropout.instance()
		listItem.currentItem = i
		get_node("%ListContainer").add_child(listItem)
		
		if get_node("%ListContainer").get_child_count() % 2 == 0:
			listItem.get_child(0).color = Color("9d000000")
			listItem.inactiveColor = Color("9d000000")
		else:
			listItem.get_child(0).color = Color("9da0a0a0")
			listItem.inactiveColor = Color("9da0a0a0")
	
	max_selected = get_node("%ListContainer").get_child_count() -1
	get_node("%ListContainer").get_child(current_seleceted)._active()

func _input(event):
	if Current_state == States.Sell:

		if Utils.get_dialog_layer().get_child_count() == 0:
			if event.is_action_pressed("S"):
				get_node("%ListContainer").get_child(current_seleceted)._inactive()
				if current_seleceted < max_selected:
					current_seleceted += 1
					get_node("%ListContainer").get_child(current_seleceted)._active()
				else:
					current_seleceted = 0
					get_node("%ListContainer").get_child(current_seleceted)._active()

			elif event.is_action_pressed("W"):
				get_node("%ListContainer").get_child(current_seleceted)._inactive()
				if current_seleceted != 0:
					current_seleceted -= 1
					get_node("%ListContainer").get_child(current_seleceted)._active()
				else:
					current_seleceted = max_selected
					get_node("%ListContainer").get_child(current_seleceted)._active()
					
		if Utils.get_dialog_layer().get_child_count() == 0:
			if event.is_action_pressed("decline"):
				holder._stop_buying_process()
		
		if event.is_action_pressed("accept"):
			if Utils.get_dialog_layer().get_child_count() == 0:
				buying = true

func _physics_process(_delta):
	if buying == true:

		if Input.is_action_pressed("D"):
			if buying_item_quantity < 999999:
				buying_item_quantity += 1
				get_node("%ListContainer").get_child(current_seleceted)._change_quantity(buying_item_quantity)
				print(buying_item_quantity)

		elif Input.is_action_pressed("A"):
			if buying_item_quantity > 1:
				buying_item_quantity -= 1
				get_node("%ListContainer").get_child(current_seleceted)._change_quantity(buying_item_quantity)
				print(buying_item_quantity)
			
		if Input.is_action_pressed("accept"):
			if Utils.get_dialog_layer().get_child_count() == 0:
				_initiate_dialog()

func _initiate_dialog():
	var dialog = DialogBar.instance()
	dialog.text_to_diaplay = first_dialog
	dialog.choices = self.options
	Utils.get_dialog_layer().add_child(dialog)

	dialog.connect("Dialog_ended",self,"_finish_dialog")

	dialog.connect("_choice_number",self,"_select_choice")

func _finish_dialog():
	buying = false
	get_node("%ListContainer").get_child(current_seleceted)._close_quantiy()
	emit_signal("start")

func _select_choice(choice):
	emit_signal("chosen")
	yield(self,"start")
	if choice == 0:
		holding_item = items[current_seleceted]
		_buy()
	elif choice == 1:
		print("sell")
	else:
		print("cancel")


func _buy():
	Holding_item = holding_item.instance()
	self.Holding_item._register()
	if self.Holding_item.type == "Free_space":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Free_space.size() != 0:
			for i in range(0,PokeHelper.Free_space.size()):
				if PokeHelper.Free_space[i].id == _Item_to_add.id:
					PokeHelper.Free_space[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Free_space")
	elif self.Holding_item.type == "Items":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Items.size() != 0:
			for i in range(0,PokeHelper.Items.size()):
				if PokeHelper.Items[i].id == _Item_to_add.id:
					PokeHelper.Items[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Items")
	elif self.Holding_item.type == "Battle_Items":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Battle_Items.size() != 0:
			for i in range(0,PokeHelper.Battle_Items.size()):
				if PokeHelper.Battle_Items[i].id == _Item_to_add.id:
					PokeHelper.Battle_Items[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Battle Items")
	elif self.Holding_item.type == "Medicine":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Medicine.size() != 0:
			for i in range(0,PokeHelper.Medicine.size()):
				if PokeHelper.Medicine[i].id == _Item_to_add.id:
					PokeHelper.Medicine[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Medicine")
	elif self.Holding_item.type == "Tm_Hm":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Tm_Hm.size() != 0:
			for i in range(0,PokeHelper.Tm_Hm.size()):
				if PokeHelper.Tm_Hm[i].id == _Item_to_add.id:
					PokeHelper.Tm_Hm[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Tm Hm")
	elif self.Holding_item.type == "Berries":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Berries.size() != 0:
			for i in range(0,PokeHelper.Berries.size()):
				if PokeHelper.Berries[i].id == _Item_to_add.id:
					PokeHelper.Berries[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Berries")
	elif self.Holding_item.type == "Pokeballs":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Pokeballs.size() != 0:
			for i in range(0,PokeHelper.Pokeballs.size()):
				if PokeHelper.Pokeballs[i].id == _Item_to_add.id:
					PokeHelper.Pokeballs[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Pokeballs")
	elif self.Holding_item.type == "Key_items":
		var _Item_to_add = self.holding_item.instance()
		_Item_to_add.count = int(buying_item_quantity)
		if PokeHelper.Key_items.size() != 0:
			for i in range(0,PokeHelper.Key_items.size()):
				if PokeHelper.Key_items[i].id == _Item_to_add.id:
					PokeHelper.Key_items[i].count += buying_item_quantity
				else:
					PokeHelper.add_child(_Item_to_add)
		else:
			PokeHelper.add_child(_Item_to_add)
		print("Key Items")
	
	buying_item_quantity = 1