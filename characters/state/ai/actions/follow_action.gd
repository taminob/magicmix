extends abstract_action

const MAX_DISTANCE: float = 30.0
const IMPORTANCE: float = 0.10

static func _internal_score(pawn: KinematicBody, event: ai_mind.sight_event) -> float:
	var target: Spatial = event.body
	if(target is StaticBody): # following a static body doesn't make any sense
		return 0.0
	if(pawn.dialogue.is_dialogue_active()):
		return 0.0
	# todo: raycast if can actually see
	var base_score: float = 0.0
	if(game.is_character(target.name)):
		base_score += abs(pawn.dialogue.get_relation(target.name)) / 10.0
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
	return range_state.out_of_range

func do(_delta: float) -> int:
	return do_state.success
