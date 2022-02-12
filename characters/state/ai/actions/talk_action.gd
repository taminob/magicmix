extends abstract_action

const MAX_DISTANCE: float = 55.0
const IMPORTANCE: float = 0.90

static func _internal_score(pawn: KinematicBody, event: ai_mind.sight_event) -> float:
	var target: Spatial = event.body
	if(!("dialogue" in target) || !(target.dialogue.can_talk())):
		return 0.0
	if(!pawn.dialogue.data.wants_to_talk_to.has(target.name)):
		return 0.0
	if(pawn.dialogue.is_dialogue_active()):
		return 0.0 # todo: decide if ai should be able to abort dialogue
	var dist: float = _distance_score(pawn, target, MAX_DISTANCE, 1.0)
	var rot: float = _rotate_score(pawn, target, 3.0)
	return dist * max(rot, 0.5) * IMPORTANCE

static func score(pawn: KinematicBody) -> Dictionary:
	var score: float
	var target: KinematicBody
	for x in pawn.ai.brain.sight_events:
		var new_score: float = _internal_score(pawn, x)
		if(score < new_score):
			score = new_score
			target = x.body
	return {
		"score": score,
		"target": target
	}

func get_range_state() -> int:
	var target: KinematicBody = data["target"]
	if(!game.is_valid(target)):
		return range_state.unreachable
	if(pawn.interaction.get_target() == target):
		return range_state.in_range
	return range_state.out_of_range

func do(_delta: float) -> int:
	pawn.interaction.initiate_interact()
	return do_state.success
