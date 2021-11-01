extends abstract_skill

class_name base_ice_skill

static func id() -> String:
	return "base_ice"

func name() -> String:
	return "Understanding of Ice"

func description() -> String:
	return "Learn to use the power of cold!\n\nGranted Spells: Ice Ball, Ice Wave"

func category() -> String:
	return "ice"

func requirements() -> Array:
	return []

func on_allocated(pawn: KinematicBody):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(ice_ball_spell.id())
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(ice_wave_spell.id())
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(ice_ride_spell.id())

func on_retracted(pawn: KinematicBody):
	pawn.inventory.remove_spell(ice_ball_spell.id())
	pawn.inventory.remove_spell(ice_wave_spell.id())
	pawn.inventory.remove_spell(ice_ride_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blue_star-512.png")
