extends Node

# warning-ignore:unused_class_variable
onready var state = get_parent()

var sturdiness
var concentration
var endurance

func experience(_xp):
	# todo: xp system
	#ui.update_xp(xp / 10)
	pass

func save(_state):
	var _experience_state = _state.get("experience", {})
	_experience_state["sturdiness"] = sturdiness
	_experience_state["concentration"] = concentration
	_experience_state["endurance"] = endurance
	_state["experience"] = _experience_state

func init(_state):
	var _experience_state = _state.get("experience", {})
	sturdiness = _experience_state.get("sturdiness", 1.0)
	concentration = _experience_state.get("concentration", 1.0)
	endurance = _experience_state.get("endurance", 1.0)
