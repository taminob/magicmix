extends Node3D

@export var next_level: String

func _ready():
	errors.debug_assert(game.levels.level_data.has(next_level)) #,"target level of door does not exist")

func get_interaction() -> String:
	return "Enter"

func interact(interactor: character):
	# todo: allow ai to transfer between levels
	if(game.mgmt.is_player(interactor)):
		game.levels.change_level(next_level)
