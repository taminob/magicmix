class_name abstract_skill

const FULL: float = 10000.0
const SKILL_ICONS_PATH: String = "res://ui/icons/skills/"
const SKILL_SCENES_PATH: String = "res://skills/scenes/"
const SKILL_ANIMS_PATH: String = "res://skills/"

static func id() -> String:
	return ""

func name() -> String:
	return ""

func description() -> String:
	return ""

func category() -> String:
	return ""

func requirements() -> Array:
	return []

func passive_effect(_pawn: character):
	pass

func start_effect(_pawn: character):
	pass

func end_effect(_pawn: character):
	pass

func effect(_pawn: character, _delta: float):
	pass

func duration() -> float:
	return -1.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../empty_slot_frame-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> PackedScene:
	return null
