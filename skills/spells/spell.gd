class_name abstract_spell

const FULL: float = 10000.0
const SKILL_ICONS_PATH: String = "res://ui/icons/skills/"
const SKILL_SCENES_PATH: String = "res://skills/scenes/"
const SKILL_ANIMS_PATH: String = "res://skills/"

func name() -> String:
	return ""

func description() -> String:
	return ""

func category() -> String:
	return ""

func combinations() -> Array:
	return []

func self_pain() -> float:
	return 0.0

func self_pain_per_second() -> float:
	return 0.0

func self_focus() -> float:
	return 0.0

func self_focus_per_second() -> float:
	return 0.0

func target_pain() -> float:
	return 0.0

func target_pain_per_second() -> float:
	return 0.0

func target_focus() -> float:
	return 0.0

func target_focus_per_second() -> float:
	return 0.0

func duration() -> float:
	return -1.0

func range() -> float:
	return -1.0

func icon() -> Resource:
	return load(SKILL_ICONS_PATH + "../empty_slot_frame-512.png")

func anim() -> String:
	return ""#SKILL_ANIMS_PATH

func scene() -> PackedScene:
	return null
