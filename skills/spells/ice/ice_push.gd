extends abstract_spell

class_name ice_push_spell

static func id() -> String:
	return "ice_push"

func name() -> String:
	return "Ice Push"

func description() -> String:
	return "Push back your enemies!"

func category() -> String:
	return "ice"

func combinations() -> Array:
	return [{
		"target": "area",
		"type": "defense",
		"elements": ["ice", "ice", "ice"]
	}]

func self_focus() -> float:
	return -40.0

func target_element() -> int:
	return element_type.ice

func target_pain() -> float:
	return 10.0

func target_focus() -> float:
	return -25.0

func casttime() -> float:
	return 0.2

func cooldown() -> float:
	return 0.0

func duration() -> float:
	return 0.5

func range() -> float:
	return 6.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/star_fall-512.png")

func scene() -> Node:
	return load(SPELL_SCENES_PATH + "ice/ice_push.tscn").instance()
