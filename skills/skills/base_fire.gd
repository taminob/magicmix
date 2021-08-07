extends abstract_skill

class_name base_fire_skill

static func id() -> String:
	return "base_fire"

func name() -> String:
	return "Understanding of Fire"

func description() -> String:
	return "Deepen your understanding of flames and heat!"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return []

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "flame-512.png")
