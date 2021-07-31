extends abstract_dialogue

func _init_statements():
	_start_statements["guenther"] = murder_witness_statement()
	_start_statements["hans"] = hans_meet_first_time()
#	statements = [
#		statement.new("Hello, my dear! My name is Mariliry!", [
#			answer.new("May I call you something shorter?", null), 
#			answer.new("I hate you!", null), 
#			answer.new("Bye!", funcref(self, "_end_dialogue"))]),
#		statement.new("Sure, just call me Mary!", [
#			answer.new("Great!", null)]),
#		statement.new("See you!", [
#			answer.new("See you!", funcref(self, "_end_dialogue"))]),
#		statement.new("Never again talk to me again!", [])
#	]

func hans_meet_first_time() -> Array:
	var statement_name: String = "hans_meet_first_time"
	var s: Dictionary = {}
	s["start"] = statement.new("Hello, my dear, I'm Mary! You look lost, can I help you?", [funcref(self, "_introduce")])
	s["where"] = statement.new("You are in the backyard of the rainbow palace, residence of our lord! How did you get here?")
	s["thief"] = statement.new("Are you a thief? How did you get in here?")
	s["leave"] = statement.new("Actually, it doesn't matter. But you should leave before the guards notice you. Hurry!")
	s["final_leave"] = statement.new("Hurry and leave!")
	s["start"].answers = [
		answer.new("Where am I?", [statement_name, "where"]),
		answer.new("Can you help me get out of here?", [statement_name, "thief"])
	]
	var no_idea_answer = answer.new("Quite honestly, I have no idea!", [statement_name, "leave"])
	s["where"].answers = [
		no_idea_answer
	]
	s["thief"].answers = [
		no_idea_answer,
		answer.new("No, of course not!", [statement_name, "leave"])
	]
	s["leave"].answers = [
		answer.new("", [statement_name, "final_leave"])
	]
	_statements[statement_name] = s
	return [statement_name, "start"]
