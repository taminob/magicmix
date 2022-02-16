extends abstract_spell

class_name freeze_wave_spell

static func id() -> String:
	return "freeze_wave"

func name() -> String:
	return "Freeze Wave"

func description() -> String:
	return "Freeze your enemies with an icy wave!"

func category() -> String:
	return "ice"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "attack",
		"elements": ["ice", "ice", "darkness"]
	}]

func self_focus() -> float:
	return -30.0

func target_element() -> int:
	return element_type.ice

func target_focus() -> float:
	return -15.0

func casttime() -> float:
	return 1.0

func cooldown() -> float:
	return 10.0

func duration() -> float:
	return 0.5

func range() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/star_fall-512.png")

func scene() -> Node:
	return preload("scene/freeze_wave.tscn").instance()
