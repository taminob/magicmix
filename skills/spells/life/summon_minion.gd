extends abstract_spell

class_name summon_minion_spell

static func id() -> String:
	return "summon_minion"

func name() -> String:
	return "Summon Minion"

func description() -> String:
	return "Summon a minion that will fight for your cause!"

func category() -> String:
	return "life"

func combinations() -> Array:
	return [{
		"target": "self",
		"type": "attack",
		"elements": ["life", "life", "life"]
	}]

func self_pain() -> float:
	return -30.0

func self_focus() -> float:
	return -10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "circle-512.png")
