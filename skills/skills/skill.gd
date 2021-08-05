class_name abstract_skill

const FULL: float = 10000.0
const SKILL_ICONS_PATH: String = "res://ui/icons/skills/"
const SKILL_SCENES_PATH: String = "res://skills/scenes/"
const SKILL_ANIMS_PATH: String = "res://skills/"

func name() -> String:
	return ""

func description() -> String:
	return ""

func category() -> String:
	return ""

func requirements() -> Array:
	return []

func passive_effect(pawn: character):
	pass

func start_effect(pawn: character):
	pass

func end_effect(pawn: character):
	pass

func effect(pawn: character, delta: float):
	pass

func duration() -> float:
	return -1.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../empty_slot_frame-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> PackedScene:
	return null
