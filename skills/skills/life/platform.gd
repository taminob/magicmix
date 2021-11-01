extends abstract_skill

class_name platform_skill

static func id() -> String:
	return "platform"

func name() -> String:
	return "Spawn Platform"

func description() -> String:
	return "Learn to manifest platforms in the air!"

func category() -> String:
	return "life"

func requirements() -> Array:
	return [invert_gravity_skill.id()]

func on_allocated(pawn: KinematicBody):
# warning-ignore:return_value_discarded
	pawn.inventory.add_spell(platform_spell.id())

func on_retracted(pawn: KinematicBody):
	pawn.inventory.remove_spell(platform_spell.id())

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../symbols/exclamation_mark-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return null
