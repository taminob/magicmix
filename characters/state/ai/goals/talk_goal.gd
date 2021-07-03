extends goal

class_name talk_goal

static func calc(know: Dictionary) -> float:
	return know["relationship"] / 10 + 1

func requirements_fulfilled() -> bool:
	return knowledge["distance"] < 2

func work_towards(delta: float) -> bool:
	if(requirements_fulfilled()):
		interact_action
		return true
	return false
