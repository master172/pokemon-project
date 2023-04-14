extends Node

func _attack():
    if self.get_parent().current_holder.opposing_pokemon.Current_attack > self.get_parent().current_holder.opposing_pokemon.Max_attack - 10:
        self.get_parent().current_holder.opposing_pokemon.Current_attack -= RandomNumberGenerator.new().randi_range(1,2)
    if self.get_parent().get_parent().get_parent() == PlayerPokemon:
        Utils.Get_Pokemon_Manger().get_child(0).enemy_turn()
        Utils.Get_Pokemon_Manger().get_child(0)._enemy_start_attack()