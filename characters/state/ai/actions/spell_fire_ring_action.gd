extends abstract_action

const DISTANCE_TOLERANCE: float = 2.0
const SHIELD_IMPACT: float = 0.8
const IMPORTANCE: float = 0.90

static func _internal_score(pawn: KinematicBody, event: ai_mind.sight_event) -> float:
	var target: Spatial = event.body
	if(!target.has_method("damage")):
		return 0.0
	var aggression: float = -0.50
	if(game.is_character(target.name)):
		aggression -= pawn.dialogue.get_relation(target.name)
	var spell: abstract_spell = skill_data.spells[fire_ring_spell.id()]
	var dist_score: float = _distance_range_score(pawn, target, [spell.range() - DISTANCE_TOLERANCE, spell.range() + DISTANCE_TOLERANCE], 1.0)
	var focus: float = pawn.stats.focus
	focus -= spell.self_focus()
	if(focus < 0.0):
		return 0.0
	var duration_score: float = (focus / -spell.self_focus_per_second()) / spell.duration()
	var element_score: float = 1.0
	if("stats" in target):
		if(spell.target_element() == target.stats.shield_element):
			element_score -= target.stats.shield_percentage() * SHIELD_IMPACT
	var score: float = aggression * dist_score * duration_score * element_score
	return clamp(score, 0.0, 1.0) * IMPORTANCE

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
	
	return range_state.out_of_range

func do(_delta: float) -> int:
	pawn.skills.cast_spell(fire_ring_spell.id())
	return do_state.success
