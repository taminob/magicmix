extends abstract_action

var current_task: task = null

static func precondition() -> ai_planner.knowledge:
	# todo: verify pain value
	return ai_planner.knowledge.new(10.0, 0, 0, 0, ai_planner.knowledge_mask.enemy_in_sight)

static func postcondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new(0, 0, 0, 0, ai_planner.knowledge_mask.enemy_damaged)

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.pain | ai_planner.knowledge_mask.enemy_in_sight | ai_planner.knowledge_mask.facing_target

static func postcondition_mask() -> int:
	return ai_planner.knowledge_mask.enemy_damaged

static func cost() -> float:
	return 5.0

func init(new_pawn: KinematicBody):
	.init(new_pawn)
	if(ResourceLoader.exists("res://characters/persons/behaviors/behavior_trees/" + pawn.name + "/behavior.tscn")):
		current_task = load("res://characters/persons/behaviors/behavior_trees/" + pawn.name + "/behavior.tscn").instance() # todo: refactor, maybe init/save for ai component
	else:
		current_task = load("res://characters/persons/behaviors/behavior_trees/default/behavior.tscn").instance()
	for x in pawn.ai.machine.get_children():
		pawn.ai.machine.remove_child(x)
	pawn.ai.machine.add_child(current_task)
	current_task.start(pawn)

func choose_target():
	target = pawn.ai.brain.get_any(ai_mind.body_type.enemy)

func get_range_state() -> int:
	return range_state.no_range_required

func do(delta: float) -> int:
	if(!current_task):
		return range_state.no_range_required
	match current_task.run(delta):
		task.task_status.NEW:
			pass
		task.task_status.CANCEL:
			pass
		task.task_status.FAIL:
			# todo: decide what to do on fail
			#current_task.reset()
			#current_task.start(pawn)
			return do_state.failure
		task.task_status.SUCCESS:
			errors.debug_output("task done: " + pawn.name)
			return do_state.success
		task.task_status.RUNNING:
			pass
	return do_state.repeat
