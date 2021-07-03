extends goal

class_name patrol_goal

func init(pawn: character):
	.init(pawn)

func requirements_fulfilled() -> bool:
	return true

static func calc(know: Dictionary) -> float:
	return 5 * float(know["pawn"].dialogue.job == "guard")

func work_towards(delta: float) -> bool:
	return true
