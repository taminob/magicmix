extends abstract_spell

class_name fire_ball_spell

static func id() -> String:
	return "fire_ball"

func name() -> String:
	return "Fire Ball"

func description() -> String:
	return "Hurl a ball of fire at your enemy!"

func category() -> String:
	return "fire"

func combinations() -> Array:
	return [{
		"target": "enemy",
		"type": "attack",
		"elements": ["fire", "fire", "fire"]
	}]

func self_focus() -> float:
	return -20.0

func target_element() -> int:
	return element_type.fire

func target_pain() -> float:
	return 30.0

func casttime() -> float:
	return 1.0

func cooldown() -> float:
	return 0.1

func duration() -> float:
	return 3.0

func range() -> float:
	return 25.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "/fire_ball-512.png")

func scene() -> Node:
	return preload("scene/fire_ball.tscn").instantiate()
