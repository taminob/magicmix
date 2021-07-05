extends goal

class_name flee_goal

static func calc(know: Dictionary) -> float:
	if(!(know["target"] as character) || know["relationship"] > 80): # if trust is high or target no character
		return 0.0
	var pawn = know["pawn"]
	return (know["pain"] / pawn.stats.max_pain()) * (1 - know["focus"] / pawn.stats.max_focus()) * 20 - know["relationship"]

const SAFE_DISTANCE_SQRD: float = 500.0
func fulfilled(know: Dictionary=knowledge) -> bool:
	return know["distance"] > SAFE_DISTANCE_SQRD || know["target"].stats.dead

func progress(know: Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	var target = know["target"]
	if(!target):
		return FULL_PROGRESS
	return max(0.0, know["distance"] - SAFE_DISTANCE_SQRD) * FULL_PROGRESS
