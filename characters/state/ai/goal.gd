class_name goal

var pawn: character

var knowledge: Dictionary = {}

var current_action: action = null

const FULL_PROGRESS: float = 100.0

func fulfilled(_know: Dictionary=knowledge) -> bool:
	return false

static func calc(_know: Dictionary) -> float:
	return 0.0

func work_towards(delta: float) -> bool:
	if(fulfilled()):
		return true
	update_knowledge(knowledge.get("target", null))
	knowledge["pawn"].move.input_direction = Vector3.ZERO
	current_action = choose_action()
	current_action.do(delta, knowledge)
	return false

func progress(know: Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	return know["pawn"].stats.max_pain() - know["pain"]

func choose_action() -> action:
	update_knowledge(knowledge.get("target", null))
	var choice: Array = [-INF, -INF, null]
	for x in _actions():
		var pre_score = x.precondition(knowledge)
		var post_score = _judge_postcondition(x.postcondition(knowledge))
		if(pre_score >= choice[0] - 1 && pre_score + post_score > choice[0] + choice[1]):
			choice = [pre_score, post_score, x]
	return choice[2].new()

func init(new_pawn: character, know: Dictionary={}):
	pawn = new_pawn
	if(!know.empty()):
		knowledge = know

func update_knowledge(target: character):
	knowledge = get_knowledge(target)

func get_knowledge(target: character) -> Dictionary:
	var know: Dictionary = {}
	know["pawn"] = pawn
	know["translation"] = pawn.global_transform.origin
	know["pain"] = pawn.stats.pain
	know["focus"] = pawn.stats.focus
	know["stamina"] = pawn.stats.stamina
	if(target):
		know["target"] = target
		know["relationship"] = pawn.dialogue.get_relationship(target.name)
		know["distance"] = pawn.global_transform.origin.distance_squared_to(target.global_transform.origin)
		know["interacting"] = false # todo: add is_interacting to interaction state
	else:
		know["target"] = null
		know["relationship"] = 0
		know["distance"] = INF
		know["interacting"] = false
	return know

func next_goal(target: Node=null) -> goal:
	var know = get_knowledge(target)
	var choice = [-INF]
	for x in _goals():
		var score = x.calc(know)
		if(score > choice[0]):
			choice = [score, x]

	var current_score = calc(knowledge) if !knowledge.empty() else 0
	if(choice[0] * 0.7 > current_score):
		var new_goal = choice[1].new()
		new_goal.init(pawn, know)
		return new_goal
	else:
		return self

func _judge_postcondition(condition: Dictionary) -> float:
	for x in knowledge.keys():
		if(!condition.has(x)):
			condition[x] = knowledge[x]
	return progress(condition)

static func _target_goals() -> Array:
	return [

	]

static func _goals() -> Array:
	return [
		load("res://characters/state/ai/goal.gd"),
		load("res://characters/state/ai/goals/patrol_goal.gd"),
		load("res://characters/state/ai/goals/talk_goal.gd"),
		load("res://characters/state/ai/goals/kill_goal.gd"),
		load("res://characters/state/ai/goals/flee_goal.gd"),
	]

static func _actions() -> Array:
	return [
		preload("res://characters/state/ai/actions/wait_action.gd"),
		preload("res://characters/state/ai/actions/interact_action.gd"),
		preload("res://characters/state/ai/actions/rotate_action.gd"),
		preload("res://characters/state/ai/actions/walk_action.gd"),
		preload("res://characters/state/ai/actions/run_action.gd"),
		preload("res://characters/state/ai/actions/sprint_action.gd"),
		preload("res://characters/state/ai/actions/cast_slot0_action.gd"),
		preload("res://characters/state/ai/actions/cast_slot1_action.gd"),
	]
