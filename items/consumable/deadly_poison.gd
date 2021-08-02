extends abstract_item

class_name deadly_poison_item

func name() -> String:
	return "Deadly Poison"

func description() -> String:
	return "This will kill you, do not drink!"

func category() -> String:
	return "consumable"

func self_pain() -> float:
	return FULL

func self_pain_per_second() -> float:
	return FULL

func self_focus() -> float:
	return -FULL

func self_focus_per_second() -> float:
	return -FULL

func duration() -> float:
	return FULL

func icon() -> Resource:
	return load(ITEM_ICONS_PATH + "poison_flask-512.png")
