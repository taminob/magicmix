extends abstract_action

const DISTANCE_TOLERANCE: float = 2.0
const SHIELD_IMPACT: float = 0.8
const IMPORTANCE: float = 0.90

static func _spell_id() -> String:
	return fire_ring_spell.id()

static func _spell() -> abstract_spell:
	return skill_data.spells[_spell_id()]

static func _spell_score(pawn: KinematicBody) -> float:
	var spell: abstract_spell = _spell()
	var focus_score: float = 1 - (-spell.self_focus() / pawn.stats.focus) if pawn.stats.focus > 0 else 0
	var focus_after_cast: float = pawn.stats.focus - spell.self_focus()
	var duration_score: float = (focus_after_cast / -spell.self_focus_per_second()) / spell.duration()
	var pain_score: float = clamp(pawn.stats.pain_percentage(), 0.5, 0.75)
	return focus_score * duration_score * pain_score

static func _internal_score(pawn: KinematicBody, event: ai_mind.sight_event) -> float:
	var target: Spatial = event.body
	if(!target.has_method("damage")):
		return 0.0
	if(!pawn.skills.can_cast(_spell_id())):
		return 0.0
	var aggression: float = -0.50
	if(game.is_character(target.name)):
		aggression -= pawn.dialogue.get_relation(target.name)
	var spell: abstract_spell = _spell()
	# todo: casttime score
	var dist_score: float = _distance_range_score(pawn, target, [spell.range() - DISTANCE_TOLERANCE, spell.range() + DISTANCE_TOLERANCE], 1.0)
	var element_score: float = 1.0
	if("stats" in target):
		if(spell.target_element() == target.stats.shield_element):
			element_score -= target.stats.shield_percentage() * SHIELD_IMPACT
	var score: float = aggression * dist_score * element_score * _spell_score(pawn)
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
	var sq_range: float = pow(_spell().range(), 2)
	if(pawn.distance_squared(target()) < sq_range):
		return range_state.in_range
	return range_state.out_of_range

func do(_delta: float) -> int:
	pawn.skills.cast_spell(_spell_id())
	return do_state.success
