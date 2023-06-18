class_name abstract_skill

const FULL: float = 10000.0
const SKILL_ICONS_PATH: String = "res://ui/icons/skills/"

static func id() -> String:
	errors.debug_assert(false) #,"abstract_skill id should not be called")
	return ""

func name() -> String:
	errors.debug_assert(false) #,"abstract_skill name should not be called")
	return ""

func description() -> String:
	errors.debug_assert(false) #,"abstract_skill description should not be called")
	return ""

func category() -> String:
	errors.debug_assert(false) #,"abstract_skill category should not be called")
	return ""

func requirements() -> Array:
	return []

func mutually_exclusive() -> Array:
	return []

func on_allocated(_pawn: CharacterBody3D):
	pass

func on_retracted(_pawn: CharacterBody3D):
	pass

func effect(_pawn: CharacterBody3D, _delta: float):
	pass

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../empty-512.png")
