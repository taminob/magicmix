extends Node

class_name experience_state

var sturdiness: float
var concentration: float
var endurance: float

# TODO: xp system
func experience_progress() -> float:
	return util.max(util.fract(sturdiness), util.fract(concentration), util.fract(endurance))

func save(state_dict: Dictionary):
	var _experience_state = state_dict.get("experience", {})
	_experience_state["sturdiness"] = sturdiness
	_experience_state["concentration"] = concentration
	_experience_state["endurance"] = endurance
	state_dict["experience"] = _experience_state

func init(state_dict: Dictionary):
	var _experience_state = state_dict.get("experience", {})
	sturdiness = _experience_state.get("sturdiness", 1.0)
	concentration = _experience_state.get("concentration", 1.0)
	endurance = _experience_state.get("endurance", 1.0)
