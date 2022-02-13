extends abstract_spell

class_name fire_ring_spell

static func id() -> String:
	return "fire_ring"

func name() -> String:
	return "Fire Ring"

func description() -> String:
	return "Summon a ring of fire to protect yourself!"

func category() -> String:
	return "fire"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "defense",
		"elements": ["fire", "fire", "darkness"]
	}]

func self_focus() -> float:
	return -5.0

func self_focus_per_second() -> float:
	return -10.0

func target_element() -> int:
	return element_type.fire

func target_pain() -> float:
	return 5.0

func target_pain_per_second() -> float:
	return 1.0

func target_focus_per_second() -> float:
	return -10.0

func casttime() -> float:
	return 1.0

func cooldown() -> float:
	return 5.0

func duration() -> float:
	return 10.0

func range() -> float:
	return 5.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/fire_ring-512.png")

func scene() -> Node:
	return preload("scene/fire_ring.tscn").instance()
