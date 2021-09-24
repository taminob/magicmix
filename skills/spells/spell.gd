class_name abstract_spell

const FULL: float = 10000.0
const SPELL_ICONS_PATH: String = "res://ui/icons/skills/"
const SPELL_SCENES_PATH: String = "res://skills/scenes/"
const SPELL_ANIMS_PATH: String = "res://skills/"

enum element_type {
	raw,
	focus,
	physical, # todo?
	life,
	darkness,
	fire,
	ice
}

static func id() -> String:
	return ""

func name() -> String:
	return ""

func description() -> String:
	return ""

func category() -> String:
	return ""

func combinations() -> Array:
	return []

func self_element() -> int:
	return element_type.raw

func self_pain() -> float:
	return 0.0

func self_pain_per_second() -> float:
	return 0.0

func self_focus() -> float:
	return 0.0

func self_focus_per_second() -> float:
	return 0.0

func target_element() -> int:
	return element_type.raw

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
	return load(SPELL_ICONS_PATH + "../empty_slot_frame-512.png")

func anim() -> String:
	return ""#SPELL_ANIMS_PATH

func scene() -> PackedScene:
	return null
