extends abstract_dialogue

func _init_statements():
	_start_statements["hans"] = want_to_arrest()
#	statements = [
#		statement.new(_arrest_sentences()[randi() % _arrest_sentences().size()], [
#			answer.new("I surrender!", funcref(self, "_no_effect")), 
#			answer.new("You'll only get me dead!", funcref(self, "_end_dialogue")), 
#			answer.new("Who are you?", 1),
#			answer.new("Why?", 1)]),
#		statement.new("No questions, back to jail with you!", [
#			answer.new("I surrender!", 2),
#			answer.new("You'll only get me dead!", 2, funcref(self, "_end_dialogue"))]),
#		statement.new("Come here, slowly. No one has to die today!", [
#			answer.new("Sure", 2, funcref(self, "_end_dialogue")),
#			answer.new("Ha, tricked you! Only one of us will survive the day.", 0, funcref(self, "_end_dialogue"))])
#	]

func want_to_arrest() -> Array:
	var statement_name: String = "some"
	_statements[statement_name] = _create_statements_from_dict({
		"start": {
			"say": _arrest_sentence(),
			"answers": [
				{
					"say": ""
				}
			]
		}
	}, [statement_name])
	return [statement_name, "start"]

func _arrest_sentence() -> String:
	return util.random_element([
		"Halt, you! You are under arrest!",
		"Stop, you are arrested!"
	])
