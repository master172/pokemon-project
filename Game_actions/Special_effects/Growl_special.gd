extends Node

func _attack():
    self.get_parent().current_holder.opposing_pokemon.Current_defense -= 10
    BattleManager.switch_turns()