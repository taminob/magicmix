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

func on_allocated(pawn: CharacterBody3D):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(invert_gravity_spell.id())

func on_retracted(pawn: CharacterBody3D):
	pawn.inventory.remove_spell(invert_gravity_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/exclamation_mark-512.png")
