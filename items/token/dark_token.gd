extends abstract_item

class_name dark_token_item

func name() -> String:
	return "Token of Darkness"

func description() -> String:
	return "Pledge your soul to the dark and strengthen your powers of the black art!"

func category() -> String:
	return "token"

func icon() -> Resource:
	return load(ITEM_ICONS_PATH + "dark_token-512.png")
