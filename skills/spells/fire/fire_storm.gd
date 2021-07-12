extends abstract_spell

class_name fire_storm_spell

func name() -> String:
	return "Fire Storm"

func description() -> String:
	return "Summon a huge fire storm and burn your foes!"

func category() -> String:
	return "fire"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "attack",
		"elements": ["fire", "fire", "darkness"]
	}]

func self_focus() -> float:
	return -30.0

func self_focus_per_second() -> float:
	return -5.0

func target_pain() -> float:
	return 5.0

func target_pain_per_second() -> float:
	return 15.0

func target_focus() -> float:
	return -1.0

func duration() -> float:
	return 25.0

func range() -> float:
	return 7.5

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "/magma-512.png")

func scene() -> PackedScene:
	return load(SKILL_SCENES_PATH + "fire/fire_storm.tscn").instance()
