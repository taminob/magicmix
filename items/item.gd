class_name abstract_item

const FULL: float = abstract_spell.FULL
const ITEM_ICONS_PATH: String = "res://ui/icons/items/"
const ITEM_SCENES_PATH: String = "res://items/"
const ITEM_ANIMS_PATH: String = "res://items/"

func name() -> String:
	errors.debug_assert(false, "abstract_item name should not be called")
	return ""

func description() -> String:
	errors.debug_assert(false, "abstract_item description should not be called")
	return ""

func category() -> String:
	errors.debug_assert(false, "abstract_item category should not be called")
	return ""

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
	errors.debug_assert(false, "abstract_item icon should not be called")
	return load(ITEM_ICONS_PATH + "../empty_slot_frame-512.png")

func anim() -> String:
	return ""#ITEM_ANIMS_PATH

func scene() -> PackedScene:
	return null
