extends abstract_skill

class_name master_fire_skill

static func id() -> String:
	return "master_fire"

func name() -> String:
	return "Mastery of Fire"

func description() -> String:
	return "Master the element of fire and destroy your enemy with enhanced heat!"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return [shield_sprint_skill.id()]

func on_allocated(_pawn: KinematicBody):
	pass # TODO: introduce fire scale factor

func on_retracted(_pawn: KinematicBody):
	pass # TODO: reset scale factor

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "flame-512.png")
