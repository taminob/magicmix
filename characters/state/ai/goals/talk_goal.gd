extends goal

class_name talk_goal

static func calc(know: Dictionary) -> float:
	return know["relationship"] / 10 + 1

func fulfilled(know:Dictionary=knowledge) -> bool:
	return know["distance"] < 2

func progress(know:Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	return max(0.0, FULL_PROGRESS - know["distance"])
