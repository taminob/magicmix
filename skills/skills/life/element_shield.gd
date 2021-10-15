extends abstract_skill

class_name element_shield_skill

static func id() -> String:
	return "element_shield"

func name() -> String:
	return "Elemental Shield"

func description() -> String:
	return "Embrace an element and learn to deflect its effects!"

func category() -> String:
	return "life"

func requirements() -> Array:
	return [base_life_skill.id()]

func start_effect(pawn: character):
	pawn.stats.shield_element = pawn.skills.current_element
	pawn.stats.shield = pawn.stats.max_shield()

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "shield-512.png")
