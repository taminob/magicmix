extends abstract_action

static func spell_id() -> String:
	return fire_ball_spell.id()

static func precondition() -> planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return planner.knowledge.new(spell.self_pain(), -spell.self_focus(), planner.knowledge_mask.enemy_in_sight)

static func postcondition() -> planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return planner.knowledge.new(spell.self_pain(), spell.self_focus(), planner.knowledge_mask.enemy_damaged)

static func precondition_mask() -> int:
	return planner.knowledge_mask.focus | planner.knowledge_mask.focus_toggle | planner.knowledge_mask.pain | planner.knowledge_mask.enemy_in_sight

static func postcondition_mask() -> int:
	return planner.knowledge_mask.focus | planner.knowledge_mask.pain | planner.knowledge_mask.enemy_damaged

func choose_target():
	target = pawn.ai.brain.get_any_enemy()

func get_range_state() -> int:
	var spell_range = skill_data.spells[spell_id()].range()
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do() -> bool:
	pawn.face_target(target)
	pawn.skills.cast_spell(spell_id())
	return true
