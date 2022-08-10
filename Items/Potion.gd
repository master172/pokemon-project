extends base_item
class_name potion

export(int)var healing_points = 20

func _use(_pokemon):
	if _pokemon.Current_health_points <= _pokemon.Max_health_points - self.healing_points:
		if _pokemon.Max_health_points - self.healing_points <= _pokemon.Current_health_points:
			_pokemon.Current_health_points += 20
			self.count -= 1
		else:
			_pokemon.Current_health_points = _pokemon.Max_health_points
			self.count -= 1
		No_effect = false
	else:
		No_effect = true


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),

		"pos_x" : position.x,
		"pos_y" : position.y,
        "count":count,
	}
	if count > 0:
		return save_dict
	else:
		self.remove_from_group("Presist")
		return null

