extends goal

class_name kill_goal

static func calc(know: Dictionary) -> float:
	return (1 - know["pain"]) * know["focus"] * 10 - know["relationship"]

func requirements_fulfilled() -> bool:
	return knowledge["target"] && knowledge["target"].stats.dead

func work_towards(_delta: float) -> bool:
	if(requirements_fulfilled()):
		return true
	pawn.skills.cast_slot(0)
	return false
