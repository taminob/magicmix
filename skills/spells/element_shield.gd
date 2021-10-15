extends abstract_spell

class_name element_shield_spell

static func id() -> String:
	return "element_shield"

func name() -> String:
	return "Elemental Shield"

func description() -> String:
	return "Protect yourself by blocking incoming elemental damage!"

func self_focus() -> float:
	return -20.0

func start_effect(pawn: KinematicBody):
	pawn.stats.shield_element = pawn.skills.current_element
	pawn.stats.shield = pawn.stats.max_shield()

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "shield-512.png")

func scene() -> Node:
	return null
	#return load(SPELL_SCENES_PATH + "").instance()
