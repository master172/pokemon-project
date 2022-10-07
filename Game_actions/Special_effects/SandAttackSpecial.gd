extends Node

func _attack():
	for i in self.get_parent().current_holder.opposing_pokemon.get_children():
		if i.Accuracy > 60:
			i.Accuracy -= RandomNumberGenerator.new().randi_range(5,7)
	BattleManager.switch_turns()