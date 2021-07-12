extends abstract_spell

class_name heal_spell

func name() -> String:
	return "Heal"

func description() -> String:
	return "Heal yourself for a bit!"

func category() -> String:
	return "life"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "attack",
		"elements": ["fire", "fire", "darkness"]
	}]

func self_pain() -> float:
	return -30.0

func self_focus() -> float:
	return -10.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "circle-512.png")
