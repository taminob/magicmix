extends abstract_spell

class_name ice_wave_spell

static func id() -> String:
	return "ice_wave"

func name() -> String:
	return "Ice Wave"

func description() -> String:
	return "Smash your enemies with an icy wave!"

func category() -> String:
	return "ice"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "attack",
		"elements": ["ice", "ice", "ice"]
	}]

func self_focus() -> float:
	return -30.0

func target_element() -> int:
	return element_type.ice

func target_pain() -> float:
	return 20.0

func target_focus() -> float:
	return -10.0

func duration() -> float:
	return 3.0

func range() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/star_fall-512.png")

func scene() -> Node:
	return preload("scene/ice_wave.tscn").instantiate()
