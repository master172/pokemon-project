extends Node2D

func _attack():
    self.get_parent().current_holder().opposing_pokemon.Current_defense -= 10