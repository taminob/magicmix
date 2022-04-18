extends Node

class_name experience_state

var sturdiness: float
var concentration: float
var endurance: float

enum level {
	novice,
	apprentice,
	master,
	grandmaster,
	god
}

var masteries: Dictionary = {}

# TODO: xp system
func experience_progress() -> float:
	return (sturdiness + concentration + endurance) / 8000.0 # return character "value"

func increase_mastery(element: int) -> int:
	if(masteries.has(element)):
		masteries[element] += 1
	else:
		masteries[element] = level.novice
	return masteries[element]

func save(state_dict: Dictionary):
	var _experience_state = state_dict.get("experience", {})
	_experience_state["sturdiness"] = sturdiness
	_experience_state["concentration"] = concentration
	_experience_state["endurance"] = endurance
	_experience_state["masteries"] = masteries
	state_dict["experience"] = _experience_state

func init(state_dict: Dictionary):
	var _experience_state = state_dict.get("experience", {})
	sturdiness = _experience_state.get("sturdiness", 1.0)
	concentration = _experience_state.get("concentration", 1.0)
	endurance = _experience_state.get("endurance", 1.0)
	masteries = _experience_state.get("masteries", {})
