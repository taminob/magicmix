extends abstract_spell

class_name invert_gravity_spell

static func id() -> String:
	return "invert_gravity"

func name() -> String:
	return "Invert Gravity"

func description() -> String:
	return "Use the natural forces and turn upside down!"

func category() -> String:
	return "life"

func start_effect(pawn: KinematicBody):
	pawn.move.gravity_direction *= -1

func end_effect(pawn: KinematicBody):
	pawn.move.gravity_direction *= -1

func duration() -> float:
	return 3.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "../symbols/exclamation_mark-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
