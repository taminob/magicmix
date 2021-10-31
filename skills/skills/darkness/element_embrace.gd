extends abstract_skill

class_name element_embrace_skill

static func id() -> String:
	return "element_embrace"

func name() -> String:
	return "Elemental Embrace"

func description() -> String:
	return "Embrace an element and bend it to your will!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return [base_darkness_skill.id()]

func mutually_exclusive() -> Array:
	return ["elment_shield"]

func effect(pawn: KinematicBody, _delta: float):
	# TODO: detect incoming damage type, reduce damage? decrease damage resistance for other elements?
	if(pawn.skills.current_element != abstract_spell.element_type.raw):
		pawn.stats.shield_element = pawn.skills.current_element
		pawn.stats.shield = pawn.stats.max_shield() / 2

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "shield-512.png")
