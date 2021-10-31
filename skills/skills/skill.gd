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

func mutually_exclusive() -> Array:
	return []

func on_allocated(_pawn: KinematicBody):
	pass

func on_retracted(_pawn: KinematicBody):
	pass

func effect(_pawn: KinematicBody, _delta: float):
	pass

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../empty-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
