extends abstract_skill

class_name taint_fire_skill

static func id() -> String:
	return "taint_fire"

func name() -> String:
	return "Taint Fire"

func description() -> String:
	return "Taint the fire you control!"

func category() -> String:
	return "darkness"

func requirements() -> Array:
	return [base_darkness_skill.id(), base_fire_skill.id(), master_fire_skill.id()]

func mutually_exclusive() -> Array:
	return ["taint_ice", "taint_life"]

func on_allocated(pawn: KinematicBody):
	# todo? improve taint mechanism
	pawn.inventory.remove_spell(fire_ring_spell.id())
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(fire_swirl_spell.id())

func on_retracted(pawn: KinematicBody):
	pawn.inventory.remove_spell(fire_swirl_spell.id())
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(fire_ring_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "blood_storm-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
