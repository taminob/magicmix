extends abstract_skill

class_name invert_gravity_skill

static func id() -> String:
	return "invert_gravity"

func name() -> String:
	return "Invert Gravity"

func description() -> String:
	return "Use the natural forces and turn upside down!"

func category() -> String:
	return "life"

func requirements() -> Array:
	return [base_life_skill.id()]

func start_effect(pawn: character):
	pawn.move.gravity_direction *= -1

func end_effect(pawn: character):
	pawn.move.gravity_direction *= -1

func duration() -> float:
	return 10.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "star_fall-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> PackedScene:
	return null
