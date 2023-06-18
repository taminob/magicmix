extends abstract_action

const SHIELD_IMPACT: float = 0.2
const IMPORTANCE: float = 0.85

static func _spell_id() -> String:
	return fire_ball_spell.id()

static func _spell() -> abstract_spell:
	return skill_data.spells[_spell_id()]

static func _spell_score(pawn: CharacterBody3D) -> float:
	var spell: abstract_spell = _spell()
	var focus_score: float = 1 - (-spell.self_focus() / pawn.stats.focus) if pawn.stats.focus > 0 else 0
	var pain_score: float = clamp(pawn.stats.pain_percentage(), 0.5, 0.75)
	return focus_score * pain_score

static func _internal_score(pawn: CharacterBody3D, event: ai_mind.sight_event) -> float:
	var target: Node3D = event.body
	if(!target.has_method("damage") || !(target is CharacterBody3D || target is RigidBody3D)):
		return 0.0
	if(!pawn.skills.can_cast(_spell_id())):
		return 0.0
	var aggression: float = -0.50
	if(game.is_character(target.name)):
		aggression -= pawn.dialogue.get_relation(target.name)
	var spell: abstract_spell = _spell()
	var dist_score: float = _distance_score(pawn, target, spell.range(), 2)
	var element_score: float = 1.0
	if("stats" in target):
		if(spell.target_element() == target.stats.shield_element):
			element_score -= target.stats.shield_percentage() * SHIELD_IMPACT
	var score: float = aggression * dist_score * element_score * _spell_score(pawn)
	return clamp(score, 0.0, 1.0) * IMPORTANCE

static func score(pawn: CharacterBody3D) -> Dictionary:
	var score: float
	var target: CharacterBody3D
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

func do(delta: float) -> int:
	var target: Node3D = target()
	var pos: Vector3 = target.global_transform.origin
	if(game.is_character(target.name)):
		pos += target.move.velocity * delta # todo? calculate actual factor based on distance and speed of projectile
	pawn.face_location(pos)
	pawn.skills.cast_spell(_spell_id())
	return do_state.success
