extends abstract_skill

class_name base_life_skill

static func id() -> String:
	return "base_life"

func name() -> String:
	return "Understanding of Life"

func description() -> String:
	return "Understand the true meaning of life and the natural forces!\n\nGranted Spell: Heal"

func category() -> String:
	return "life"

func requirements() -> Array:
	return []

func on_allocated(pawn: character):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(heal_spell.id())

func on_retracted(pawn: character):
	pawn.inventory.remove_spell(heal_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "circle-512.png")
