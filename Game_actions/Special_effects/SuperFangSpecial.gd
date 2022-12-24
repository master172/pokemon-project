extends Node


func _attack():
    if self.get_parent().current_holder.opposing_pokemon.Current_health_points/2 > 1:
        self.get_parent().current_holder.opposing_pokemon.Current_health_points = (self.get_parent().current_holder.opposing_pokemon.Current_health_points/2)
    else:
        self.get_parent().current_holder.opposing_pokemon.Current_health_points -= 1
