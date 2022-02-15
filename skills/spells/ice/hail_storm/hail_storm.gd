extends abstract_spell

class_name hail_storm_spell

static func id() -> String:
	return "hail_storm"

func name() -> String:
	return "Hail Storm"

func description() -> String:
	return "Summon a huge storm of hails and beat your foes to death!"

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

func self_focus_per_second() -> float:
	return -5.0

func target_element() -> int:
	return element_type.fire

func target_pain() -> float:
	return 15.0

func target_focus() -> float:
	return -10.0

func casttime() -> float:
	return 2.5

func cooldown() -> float:
	return 10.0

func duration() -> float:
	return 25.0

func range() -> float:
	return 7.5

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/star_fall-512.png")

func scene() -> Node:
	return preload("scene/hail_storm.tscn").instance()
