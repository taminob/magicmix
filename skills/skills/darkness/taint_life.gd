extends abstract_skill

class_name taint_life_skill

static func id() -> String:
	return "taint_life"

func name() -> String:
	return "Taint Life"

func description() -> String:
	return "Taint the life you control!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return [base_darkness_skill.id()]

func mutually_exclusive() -> Array:
	return [taint_fire_skill.id(), taint_ice_skill.id()]

func on_allocated(_pawn: KinematicBody):
	pass # TODO: implement taint

func on_retracted(_pawn: KinematicBody):
	pass

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blood_storm-512.png")
