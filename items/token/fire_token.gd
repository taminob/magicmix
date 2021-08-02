extends abstract_item

class_name fire_token_item

func name() -> String:
	return "Token of Fire"

func description() -> String:
	return "Pledge your soul to the fire and increase your control over all heat!"

func category() -> String:
	return "token"

func icon() -> Resource:
	return load(ITEM_ICONS_PATH + "fire_token-512.png")
