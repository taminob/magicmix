extends goal

class_name kill_goal

static func calc(know: Dictionary) -> float:
	return (1 - know["pain"]) * know["focus"] * 10 - know["relationship"]

func fulfilled(know:Dictionary=knowledge) -> bool:
	return know["target"] && know["target"].stats.dead

const NO_CHASE_DISTANCE_SQRD: float = 200.0;
func progress(know:Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	var progress = know["target"].stats.pain / know["target"].stats.max_pain() * FULL_PROGRESS
	progress -= max(0.0, NO_CHASE_DISTANCE_SQRD - know["distance"]) * FULL_PROGRESS * 0.4
	return progress
