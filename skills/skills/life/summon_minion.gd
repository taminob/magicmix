extends abstract_skill

class_name summon_minion_skill

static func id() -> String:
	return "summon_minion"

func name() -> String:
	return "Summon Minion"

func description() -> String:
	return "Learn to breath life into a minion!"

func category() -> String:
	return "life"

func requirements() -> Array:
	return [base_life_skill.id()]

func on_allocated(pawn: CharacterBody3D):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(summon_minion_spell.id())

func on_retracted(pawn: CharacterBody3D):
	pawn.inventory.remove_spell(summon_minion_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "enemy-512.png")
