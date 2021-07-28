extends abstract_dialogue

func _init_statements():
	statements = [
		statement.new("Hey {partner} :)\nYou actually found an unimplemented dialogue, feel free to contact the devs and help improving the game!",
		[answer.new("Alright, on my way!", funcref(self, "_end_dialogue")), 
			answer.new("Definetly not going to do that, hate this game!", funcref(self, "_end_dialogue")), 
			answer.new("Bye!", funcref(self, "_end_dialogue"))])
	]
