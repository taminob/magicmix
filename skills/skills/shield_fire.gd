extends abstract_skill

class_name shield_fire_skill

static func id() -> String:
	return "shield_fire"

func name() -> String:
	return "Fire Shield"

func description() -> String:
	return "Embrace the fire and learn to deflect heat!"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return ["base_fire"]

func start_effect(pawn: character):
	pawn.stats.shield_element = abstract_spell.element_type.fire
	pawn.stats.shield = pawn.stats.max_shield()

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "shield-512.png")
