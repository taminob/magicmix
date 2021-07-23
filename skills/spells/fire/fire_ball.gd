extends abstract_spell

class_name fire_ball_spell

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

func target_pain() -> float:
	return 30.0

func duration() -> float:
	return 3.0

func range() -> float:
	return 25.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "/fire_ball-512.png")

func scene() -> PackedScene:
	return load(SKILL_SCENES_PATH + "fire/fire_ball.tscn").instance()
