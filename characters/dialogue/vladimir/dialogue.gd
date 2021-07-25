extends abstract_dialogue

func _init_statements():
	statements = [
		statement.new("Halt, you! Arrest him!", [
			answer.new("I surrender!", 2), 
			answer.new("You'll only get me dead!", 0, funcref(self, "_end_dialogue")), 
			answer.new("Who are you?", 1),
			answer.new("Why?", 1)]),
		statement.new("No questions, back to jail with you!", [
			answer.new("I surrender!", 2),
			answer.new("You'll only get me dead!", 2, funcref(self, "_end_dialogue"))]),
		statement.new("Come here, slowly. No one has to die today!", [
			answer.new("Sure", 2, funcref(self, "_end_dialogue")),
			answer.new("Ha, tricked you! Only one of us will survive the day.", 0, funcref(self, "_end_dialogue"))])
	]
