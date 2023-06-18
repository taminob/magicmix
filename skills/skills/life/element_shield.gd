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

func mutually_exclusive() -> Array:
	return ["element_embrace"]

func on_allocated(pawn: CharacterBody3D):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(element_shield_spell.id())

func on_retracted(pawn: CharacterBody3D):
	pawn.inventory.remove_spell(element_shield_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "shield-512.png")
