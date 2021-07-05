extends goal

class_name kill_goal

static func calc(know: Dictionary) -> float:
	if(!(know["target"] as character) || know["relationship"] > 50):
		return 0.0
	var pawn = know["pawn"]
	return (1 - know["pain"] / pawn.stats.max_pain()) * (know["focus"] / pawn.stats.max_focus()) * 20 - pow((know["relationship"] + 20) / 10, 3)

func fulfilled(know: Dictionary=knowledge) -> bool:
	return !(know["target"] as character) || (know["target"] && know["target"].stats.dead)

const NO_CHASE_DISTANCE_SQRD: float = 200.0;
func progress(know: Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	var target = know["target"]
	if(!(target as character)):
		return 0.0
	var progress = know["target"].stats.pain / know["target"].stats.max_pain() * FULL_PROGRESS
	progress -= max(0.0, NO_CHASE_DISTANCE_SQRD - know["distance"]) * FULL_PROGRESS * 0.4
	return progress
