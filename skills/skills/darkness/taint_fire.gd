extends abstract_skill

class_name taint_fire_skill

static func id() -> String:
	return "taint_fire"

func name() -> String:
	return "Taint Fire"

func description() -> String:
	return "Taint the fire you control!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return [base_darkness_skill.id()]

func mutually_exclusive() -> Array:
	return ["taint_ice", "taint_life"]

func on_allocated(_pawn: KinematicBody):
	pass # TODO: implement taint

func on_retracted(_pawn: KinematicBody):
	pass

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blood_storm-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
