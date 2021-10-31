extends abstract_skill

class_name base_fire_skill

static func id() -> String:
	return "base_fire"

func name() -> String:
	return "Understanding of Fire"

func description() -> String:
	return "Deepen your understanding of flames and heat!\n\nGranted Spells: Fire Ball, Fire Storm, Fire Ring"

func category() -> String:
	return "fire"

func requirements() -> Array:
	return []

func on_allocated(pawn: KinematicBody):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(fire_ball_spell.id())
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(fire_storm_spell.id())
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(fire_ring_spell.id())

func on_retracted(pawn: KinematicBody):
	pawn.inventory.remove_spell(heal_spell.id())
	pawn.inventory.remove_spell(fire_storm_spell.id())
	pawn.inventory.remove_spell(fire_ring_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "flame-512.png")
