extends base_item
class_name potion



func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),

		"pos_x" : position.x,
		"pos_y" : position.y,
        "count":count,
	}
	return save_dict

