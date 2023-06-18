class_name abstract_spell

const FULL: float = 10000.0
const SPELL_ICONS_PATH: String = "res://ui/icons/skills/"
const SPELL_ANIMS_PATH: String = "res://skills/"

enum element_type {
	raw,
	focus,
	stamina,
	physical, # todo?
	life,
	darkness,
	fire,
	ice
}

enum spell_type {
	shield,
	area,
	target,
	special
}

static func id() -> String:
	errors.debug_assert(false, "abstract_spell id should not be called")
	return ""

func name() -> String:
	errors.debug_assert(false, "abstract_spell name should not be called")
	return ""

func description() -> String:
	errors.debug_assert(false, "abstract_spell description should not be called")
	return ""

func category() -> String:
	errors.debug_assert(false, "abstract_spell category should not be called")
	return ""

func base_element() -> int:
	match category():
		"life":
			return element_type.life
		"fire":
			return element_type.fire
		"ice":
			return element_type.ice
		"darkness":
			return element_type.darkness
	return element_type.raw

func type() -> int:
	return spell_type.special

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

func start_effect(_pawn: CharacterBody3D):
	pass

func end_effect(_pawn: CharacterBody3D):
	pass

func effect(_pawn: CharacterBody3D, _delta: float):
	pass

func casttime() -> float:
	return 0.0

func cooldown() -> float:
	return 0.0

func duration() -> float:
	return -1.0

func range() -> float:
	return -1.0

func icon() -> Resource:
	return load(SPELL_ICONS_PATH + "../empty-512.png")

func anim() -> String:
	return ""#SPELL_ANIMS_PATH

func scene() -> Node:
	return null
