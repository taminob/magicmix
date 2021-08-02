extends abstract_item

class_name dark_potion_item

func name() -> String:
	return "Dark Potion"

func description() -> String:
	return "Consume dark spirits and let their power guide you!"

func category() -> String:
	return "consumable"

func self_pain() -> float:
	return 10.0

func self_pain_per_second() -> float:
	return 1.0

func duration() -> float:
	return 30.0

func icon() -> Resource:
	return load(ITEM_ICONS_PATH + "dark_potion-512.png")
