extends action


static func precondition(know: Dictionary) -> float:
	if(!know["target"]):
		return 0.0
	var score: float = max(0.0, action.PERFECT_SCORE - know["distance"] - 50 * int(know["interacting"]))
	var interact_target = know["pawn"].interaction.interact_target
	if(score > action.PERFECT_SCORE - 1 && interact_target == know["target"] && !know["interacting"]):
		return action.PERFECT_SCORE
	return score

static func postcondition(know: Dictionary) -> Dictionary:
	return {
		"interacting": !know["interacting"]
	}

func do(_delta: float, know: Dictionary):
	know["pawn"].interaction.initiate_interact()
	know["interacting"] = !know["interacting"]
