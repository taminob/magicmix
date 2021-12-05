extends abstract_spell

class_name heal_spell

static func id() -> String:
	return "heal"

func name() -> String:
	return "Heal"

func description() -> String:
	return "Heal yourself for a bit!"

func category() -> String:
	return "life"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "defense",
		"elements": ["life"]
	}]

func self_pain() -> float:
	return -30.0

func self_focus() -> float:
	return -10.0

func casttime() -> float:
	return 1.0

func cooldown() -> float:
	return 5.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "circle-512.png")
