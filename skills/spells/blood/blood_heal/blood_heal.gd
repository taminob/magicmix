extends abstract_spell

class_name blood_heal_spell

static func id() -> String:
	return "blood_heal"

func name() -> String:
	return "Blood Heal"

func description() -> String:
	return "Give yourself to the pain of your surrounding!"

func category() -> String:
	return "blood"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "defense",
		"elements": ["life", "life", "darkness"]
	}]

func self_pain() -> float:
	return 80.0

func self_focus() -> float:
	return 20.0

func target_pain() -> float:
	return -40.0

func target_focus() -> float:
	return 50.0

func duration() -> float:
	return 1.0

func range() -> float:
	return 7.1

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "blood_scratch-512.png")

func scene() -> Node:
	return load("blood/blood_heal.tscn").instance()