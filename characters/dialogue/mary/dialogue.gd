extends abstract_dialogue

func _init_statements():
	statements = [
		statement.new("Hello, my dear! My name is Mariliry!", [
			answer.new("May I call you something shorter?", 1), 
			answer.new("I hate you!", 1), 
			answer.new("Bye!", 0, funcref(self, "_end_dialogue"))]),
		statement.new("Sure, just call me Mary!", [
			answer.new("Great!", 2)]),
		statement.new("See you!", [
			answer.new("See you!", 2, funcref(self, "_end_dialogue"))]),
		statement.new("Never again talk to me again!", [])
	]
