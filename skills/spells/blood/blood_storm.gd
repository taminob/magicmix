extends abstract_spell

class_name blood_storm_spell

func name() -> String:
	return "Blood Storm"

func description() -> String:
	return "Sacrifice a part of yourself to summon a deadly storm!"

func category() -> String:
	return "blood"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "attack",
		"elements": ["fire", "life", "darkness"]
	}]

func self_pain() -> float:
	return 20.0

func self_pain_per_second() -> float:
	return 10.0

func self_focus() -> float:
	return -20.0

func self_focus_per_second() -> float:
	return -15.0

func target_pain_per_second() -> float:
	return 40.0

func target_focus() -> float:
	return -5.0

func duration() -> float:
	return 15.0

func range() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "blood_storm-512.png")

func scene() -> PackedScene:
	return load(SPELL_SCENES_PATH + "blood/blood_storm.tscn").instance()
