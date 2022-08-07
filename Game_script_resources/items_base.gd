extends Node2D
class_name base_item

export(Texture) var sprite
export(String) var Name
export(String , MULTILINE) var Description
export(int) var count = 1
export(String,"Free_space","Items","Battle_Items","Medicine","Tm_Hm","Berries","Pokeballs","Key_items") var type 

func _register():
    print("Registering")