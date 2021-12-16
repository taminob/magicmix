extends abstract_action

static func spell_id() -> String:
	return blood_storm_spell.id()

static func precondition() -> ai_planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return ai_planner.knowledge.new(spell.self_pain() + spell.self_pain_per_second(), -spell.self_focus() - spell.self_focus_per_second(), 0, 0, ai_planner.knowledge_mask.enemy_in_near)

static func postcondition() -> ai_planner.knowledge:
	var spell = skill_data.spells[spell_id()]
	return ai_planner.knowledge.new(spell.self_pain(), spell.self_focus(), 0, 0, ai_planner.knowledge_mask.enemy_damaged)

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.focus | ai_planner.knowledge_mask.focus_toggle | ai_planner.knowledge_mask.pain | ai_planner.knowledge_mask.enemy_in_near

static func postcondition_mask() -> int:
	return ai_planner.knowledge_mask.focus | ai_planner.knowledge_mask.pain | ai_planner.knowledge_mask.enemy_damaged

static func cost() -> float:
	return 1.5

func choose_target():
	target = pawn.ai.brain.get_any()

func get_range_state() -> int:
	if(!game.is_valid(target)):
		return range_state.unreachable
	var spell_range = skill_data.spells[spell_id()].range()
	if(spell_range < 0):
		return range_state.no_range_required
	if(pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) <= spell_range * spell_range):
		return range_state.in_range
	return range_state.out_of_range

func do(_delta: float) -> int:
	pawn.face_target(target)
	pawn.skills.cast_spell(spell_id())
	return do_state.success
