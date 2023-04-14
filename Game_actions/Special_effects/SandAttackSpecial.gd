extends Node

func _attack():
	for i in self.get_parent().current_holder.opposing_pokemon.get_children():
		if i.Accuracy > 60:
			i.Accuracy -= RandomNumberGenerator.new().randi_range(5,7)
	if self.get_parent().get_parent().get_parent() == PlayerPokemon:
		Utils.Get_Pokemon_Manger().get_child(0).enemy_turn()
		Utils.Get_Pokemon_Manger().get_child(0)._enemy_start_attack()
