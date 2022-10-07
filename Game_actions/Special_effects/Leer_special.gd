extends Node

func _attack():
    if self.get_parent().current_holder.opposing_pokemon.Current_attack > self.get_parent().current_holder.opposing_pokemon.Max_attack - 10:
        self.get_parent().current_holder.opposing_pokemon.Current_attack -= RandomNumberGenerator.new().randi_range(1,2)
    BattleManager.switch_turns()