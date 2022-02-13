extends abstract_action

const MAX_DISTANCE: float = 30.0
const IMPORTANCE: float = 0.10

static func _internal_score(pawn: KinematicBody, event: ai_mind.sight_event) -> float:
	var target: Spatial = event.body
	if(pawn.dialogue.is_dialogue_active()):
		return 0.0
	# todo: raycast if can actually see
	var base_score: float = 0.0
	if(game.is_character(target.name)):
		base_score += abs(pawn.dialogue.get_relation(target.name)) / 10.0
	elif(target is StaticBody): # TODO: there might be interesting static bodies
		base_score -= 0.5
	var dist: float = _distance_score(pawn, target, MAX_DISTANCE, 3.0)
	var rot: float = _rotate_score(pawn, target, 1.0)
	var score: float = base_score + dist * max(rot, 0.2)
	return clamp(score, 0.0, 1.0) * IMPORTANCE

static func score(pawn: KinematicBody) -> Dictionary:
	var score: float
	var target: Spatial
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
	return range_state.no_range_required

func do(_delta: float) -> int:
	pawn.face_target(target())
	return do_state.success
