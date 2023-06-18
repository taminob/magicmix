extends Node

@onready var ai: Node = $".."
var action_classes: Array

func _ready():
	# TODO: move to static array?
	var dir: DirAccess = DirAccess.new()
	errors.debug_assert(dir.open("res://characters/state/ai/actions/") == OK) #,"unable to find ai actions directory")
	errors.error_test(dir.list_dir_begin() )# TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	while true:
		var file: String = dir.get_next()
		if(file.is_empty()):
			break
		var action = load(dir.get_current_dir() + file)
		action_classes.push_back(action)
	dir.list_dir_end()

func best_action() -> abstract_action:
	var best_class: Resource = abstract_action
	var best_data: Dictionary = {"score": 0.0}
	# todo: scores could be calculated multi-threaded
	for action_class in action_classes:
		var data: Dictionary = action_class.score(ai.pawn)
		if(best_data["score"] < data["score"]):
			best_class = action_class
			best_data = data
	var new_action = best_class.new()
	new_action.init(ai.pawn, best_data)
	return new_action
