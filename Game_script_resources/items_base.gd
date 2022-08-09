extends Node2D
class_name base_item


export(int) var id
export(Texture) var sprite
export(String) var Name
export(String , MULTILINE) var Description
export(int) var count = 1
export(String,"Free_space","Items","Battle_Items","Medicine","Tm_Hm","Berries","Pokeballs","Key_items") var type 

func _register():
    print("Registering")

func _ready():
    yield(get_tree().create_timer(0.2),"timeout")
    if self.get_parent() == PokeHelper:
        if self.type == "Battle_Items":
            PokeHelper.Battle_Items.append(self)
        elif self.type == "Items":
            PokeHelper.Items.append(self)
        elif self.type == "Free_space":
            PokeHelper.Free_space.append(self)
        elif self.type == "Medicine":
            PokeHelper.Medicine.append(self)
        elif self.type == "Tm_Hm":
            PokeHelper.Tm_Hm.append(self)
        elif self.type == "Berries":
            PokeHelper.Berries.append(self)
        elif self.type == "Pokeballs":
            PokeHelper.Pokeballs.append(self)
        elif self.type == "Key_items":
            PokeHelper.Key_items.append(self)