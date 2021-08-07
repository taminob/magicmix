extends abstract_spell

class_name blood_sacrifice_spell

static func id() -> String:
	return "blood_sacrifice"

func name() -> String:
	return "Blood Sacrifice"

func description() -> String:
	return "Sacrifice your own life (or an innocent creature) to revive the nearest human!"

func category() -> String:
	return "blood"

func combinations() -> Array:
	return [{
		"target": "self",
		"type": "defense",
		"elements": ["life", "life", "darkness"]
	}]

func self_pain() -> float:
	return FULL

func self_focus() -> float:
	return FULL

func target_pain() -> float:
	return -FULL

func target_focus() -> float:
	return -FULL

func duration() -> float:
	return 0.5

func range() -> float:
	return 4.3

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "self_dark-512.png")

func scene() -> PackedScene:
	return load(SPELL_SCENES_PATH + "blood/blood_sacrifice.tscn").instance()
