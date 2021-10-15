extends abstract_skill

class_name base_darkness_skill

static func id() -> String:
	return "base_darkness"

func name() -> String:
	return "Understanding of The Dark"

func description() -> String:
	return "Understand the shadows and step into the dark!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return []

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "darkness-512.png")
