extends abstract_skill

class_name taint_ice_skill

static func id() -> String:
	return "taint_ice"

func name() -> String:
	return "Taint Ice"

func description() -> String:
	return "Taint the ice you control!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return [base_darkness_skill.id()]

func on_allocated(pawn: character):
	pass # TODO: implement taint

func on_retracted(pawn: character):
	pass

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blood_storm-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
