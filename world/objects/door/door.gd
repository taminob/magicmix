extends Spatial

export var next_level: String

func _ready():
	assert(game.levels.levels.has(next_level), "target level of door does not exist")

func get_interaction() -> String:
	return "Enter"

func interact(interactor: character):
	# todo: allow ai to transfer between levels
	if(game.mgmt.is_player(interactor)):
		game.levels.change_level(next_level)
