extends abstract_spell

class_name fire_swirl_spell

static func id() -> String:
	return "fire_swirl"

func name() -> String:
	return "Fire Swirl"

func description() -> String:
	return "Radiate fire and destroy your foes!"

func category() -> String:
	return "fire"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "attack",
		"elements": ["fire", "fire", "fire"]
	}]

func self_focus() -> float:
	return -5.0

func self_focus_per_second() -> float:
	return -20.0

func target_element() -> int:
	return element_type.fire

func target_pain() -> float:
	return 5.0

func target_pain_per_second() -> float:
	return 1.0

func target_focus_per_second() -> float:
	return -5.0

func casttime() -> float:
	return 1.0

func cooldown() -> float:
	return 10.0

func duration() -> float:
	return 15.0

func range() -> float:
	return 20.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/fire_ring-512.png")

func scene() -> Node:
	return preload("scene/fire_swirl.tscn").instantiate()
