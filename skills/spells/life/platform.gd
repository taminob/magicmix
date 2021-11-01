extends abstract_spell

class_name platform_spell

static func id() -> String:
	return "platform"

func name() -> String:
	return "Spawn Platform"

func description() -> String:
	return "Use the natural forces and spawn temporary platforms!"

func category() -> String:
	return "life"

func self_focus_per_second() -> float:
	return -10.0

func duration() -> float:
	return 10.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "../symbols/exclamation_mark-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> Node:
	return load(SPELL_SCENES_PATH + "life/platform.tscn").instance()
