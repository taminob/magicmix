extends abstract_action

const SHIELD_IMPACT: float = 0.2
const IMPORTANCE: float = 0.85

static func _spell_id() -> String:
	return ice_push_spell.id()

static func _spell() -> abstract_spell:
	return skill_data.spells[_spell_id()]

static func _spell_score(pawn: KinematicBody) -> float:
	var spell: abstract_spell = _spell()
	var focus_score: float = 1 - (-spell.self_focus() / pawn.stats.focus())
	var pain_score: float = clamp(pawn.stats.pain_percentage(), 0.5, 0.75)
	return focus_score * pain_score

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
	var dist_score: float = _distance_score(pawn, target, spell.range())
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
	var target: KinematicBody = data["target"]
	if(!game.is_valid(target)):
		return range_state.unreachable
	var sq_range: float = pow(_spell().range(), 2)
	if(pawn.distance_squared(target) < sq_range):
		return range_state.in_range
	return range_state.out_of_range

func do(_delta: float) -> int:
	pawn.skills.cast_spell(_spell_id())
	return do_state.success
