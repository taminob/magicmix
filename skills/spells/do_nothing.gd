extends abstract_spell

class_name do_nothing_spell

static func id() -> String:
	return ""

func name() -> String:
	return "Do Nothing"

func description() -> String:
	return "Lose yourself in boredom!"

func category() -> String:
	return ""

func self_focus() -> float:
	return -5.0
