extends abstract_dialogue

func _init_statements():
	statements = [
		statement.new("I'm dead. At the same time, I'm not. Confusing sometimes.", [
			answer.new("What's your name?", 1), 
			answer.new("What's it like?", 1), 
			answer.new("Bye!", 0, funcref(self, "_end_dialogue"))]),
		statement.new("Oh, sorry. I didn't notice you, was just talking to myself. I'm Günther, what did you say?", [
			answer.new("Just asking for your name.", 2), 
			answer.new("Never mind", 3), 
			answer.new("Don't mind me, see you.", 0, funcref(self, "_end_dialogue"))]),
		statement.new("Oh, sorry. I didn't notice you, was just talking to myself. I'm Günther, what did you say?", []),
		statement.new("Alright, see you!", [])
	]
