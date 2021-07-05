extends goal

class_name patrol_goal

func fulfilled(_know: Dictionary=knowledge) -> bool:
	return false

func progress(know: Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	return 0.0

static func calc(know: Dictionary) -> float:
	return 0 * float(know["pawn"].dialogue.job == "guard")
