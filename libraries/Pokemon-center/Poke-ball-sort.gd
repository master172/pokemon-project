extends YSort



func _sort():
	self.get_child(0).visible = PlayerPokemon.first_pokemon != null
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(1).visible = PlayerPokemon.second_pokemon != null
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(2).visible = PlayerPokemon.third_pokemon != null
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(3).visible = PlayerPokemon.fourth_pokemon != null
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(4).visible = PlayerPokemon.fifth_pokemon != null
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(5).visible = PlayerPokemon.sixth_pokemon != null
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(0).get_child(0).play("Heal")
	self.get_child(2).get_child(0).play("Heal")
	self.get_child(3).get_child(0).play("Heal")
	self.get_child(1).get_child(0).play("Heal")
	self.get_child(4).get_child(0).play("Heal")
	self.get_child(5).get_child(0).play("Heal")

func _unsort():
	self.get_child(5).visible = (PlayerPokemon.sixth_pokemon == null and self.get_child(5).visible == true)
	self.get_child(5).get_child(0).playing = false
	self.get_child(5).get_child(0).frame = 0
	
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(4).visible = (PlayerPokemon.fifth_pokemon == null and self.get_child(4).visible == true)
	self.get_child(4).get_child(0).playing = false
	self.get_child(4).get_child(0).frame = 0
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(3).visible = (PlayerPokemon.fourth_pokemon == null and self.get_child(3).visible == true)
	self.get_child(3).get_child(0).playing = false
	self.get_child(3).get_child(0).frame = 0
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(2).visible = (PlayerPokemon.third_pokemon == null and self.get_child(2).visible == true)
	self.get_child(2).get_child(0).playing = false
	self.get_child(2).get_child(0).frame = 0
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(1).visible = (PlayerPokemon.second_pokemon == null and self.get_child(1).visible == true)
	self.get_child(1).get_child(0).playing = false
	self.get_child(1).get_child(0).frame = 0
	yield(get_tree().create_timer(0.3),"timeout")
	self.get_child(0).visible = (PlayerPokemon.first_pokemon == null and self.get_child(0).visible == true)
	self.get_child(0).get_child(0).playing = false
	self.get_child(0).get_child(0).frame = 0
	yield(get_tree().create_timer(0.3),"timeout")

	
	
	

	
	