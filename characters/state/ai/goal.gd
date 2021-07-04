class_name goal

var pawn: character

var knowledge: Dictionary = {
	"pawn": null,
	"translation": Vector3.ZERO,
	"pain": 0,
	"focus": 0,
	"stamina": 0,
	"target": null,
	"relationship": 0,
	"distance": 0,
	"interacting": false,
}

var current_action: action = null

const FULL_PROGRESS: float = 100.0

func fulfilled(_know:Dictionary=knowledge) -> bool:
	return false

static func calc(_know: Dictionary) -> float:
	return 0.0

func work_towards(delta: float) -> bool:
	if(fulfilled()):
		return true
	update_knowledge(knowledge["target"])
	current_action = choose_action()
	current_action.do(delta, knowledge)
	return false

func progress(know:Dictionary=knowledge) -> float:
	if(fulfilled(know)):
		return FULL_PROGRESS
	return 0.0

func choose_action() -> action:
	update_knowledge(knowledge["target"])
	var choice: Array = [-INF, -INF, null]
	for x in _actions():
		var pre_score = x.precondition(knowledge)
		var post_score = _judge_postcondition(x.postcondition(knowledge))
		if(pre_score >= choice[0] - 1 && pre_score + post_score > choice[0] + choice[1]):
			choice = [pre_score, post_score, x]
	return choice[2].new()

func init(new_pawn: character, know:Dictionary={}):
	pawn = new_pawn
	if(!know.empty()):
		knowledge = know

func update_knowledge(target: character):
	knowledge["pawn"] = pawn
	knowledge["pain"] = pawn.stats.pain
	knowledge["focus"] = pawn.stats.focus
	knowledge["stamina"] = pawn.stats.stamina
	if(target):
		knowledge["relationship"] = pawn.dialogue.get_relationship(target.name)
		knowledge["distance"] = pawn.global_transform.origin.distance_squared_to(target.global_transform.origin)
		knowledge["target"] = target

func next_goal(target:character=null) -> goal:
	update_knowledge(target)
	var choice = [-INF]
	for x in _goals():
		var score = x.calc(knowledge)
		if(score > choice[0]):
			choice = [score, x]
	if(target):
		for x in _target_goals():
			var score = x.calc(knowledge)
			if(score > choice[0]):
				choice = [score, x]

	var current_score = calc(knowledge)
	if(choice[0] * 0.5 > current_score):
		var new_goal = choice[1].new()
		new_goal.init(pawn, knowledge)
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
		load("res://characters/state/ai/goals/talk_goal.gd"),
		load("res://characters/state/ai/goals/kill_goal.gd"),
	]

static func _goals() -> Array:
	return [
		load("res://characters/state/ai/goal.gd"),
		load("res://characters/state/ai/goals/patrol_goal.gd"),
	]

static func _actions() -> Array:
	return [
		load("res://characters/state/ai/actions/interact_action.gd"),
		load("res://characters/state/ai/actions/walk_action.gd"),
		load("res://characters/state/ai/actions/sprint_action.gd"),
		load("res://characters/state/ai/actions/run_action.gd"),
		load("res://characters/state/ai/actions/wait_action.gd"),
		load("res://characters/state/ai/actions/rotate_action.gd"),
		load("res://characters/state/ai/actions/cast_slot0_action.gd"),
	]
