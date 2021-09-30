extends abstract_skill

class_name base_ice_skill

static func id() -> String:
	return "base_ice"

func name() -> String:
	return "Understanding of Ice"

func description() -> String:
	return "Learn to use the power of cold!"

func category() -> String:
	return "ice"

func requirements() -> Array:
	return []

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blue_star-512.png")
