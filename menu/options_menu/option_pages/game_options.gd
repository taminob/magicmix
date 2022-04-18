extends ScrollContainer

func _ready():
	init_difficulty_selection()

func init_difficulty_selection():
	var difficulty_choice: OptionButton = $"layout/difficulty/difficulty_choice"
	for difficulty in range(game_settings.difficulties.size()):
		difficulty_choice.add_item(game_settings.get_difficulty_name(difficulty))
	difficulty_choice.selected = settings.get_setting("game", "difficulty")

func _on_difficulty_choice_item_selected(index: int):
	settings.set_setting("game", "difficulty", index)
	game_settings.set_difficulty(index)
