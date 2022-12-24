extends Node


func _attack():
    if self.get_parent().current_holder.opposing_pokemon.Current_defense > self.get_parent().current_holder.opposing_pokemon.Max_defense - 10:
        self.get_parent().current_holder.opposing_pokemon.Current_defense -= RandomNumberGenerator.new().randi_range(1,2)
    BattleManager._incrementTurns()
    BattleManager.switch_turns()