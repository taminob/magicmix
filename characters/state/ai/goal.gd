class_name goal

var pawn: character

var knowledge: Dictionary = {
	"pawn": null,
	"pain": 0,
	"focus": 0,
	"stamina": 0,
	"target": null,
	"relationship": 0,
	"distance": 0,
}

var requirements: Dictionary = {}

func requirements_fulfilled() -> bool:
	for x in requirements:
		if(!x[1].fulfilled(knowledge[x[0]])):
			return false
	return true

static func calc(knowledge: Dictionary) -> float:
	return 0.0

func work_towards(_delta: float) -> bool:
	return false

func init(new_pawn: character):
	pawn = new_pawn

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
	for x in goals():
		var score = x[1].call_func(knowledge)
		if(score > choice[0]):
			choice = [score, x[0]]
	if(target):
		for x in target_goals():
			var score = x[1].call_func(knowledge)
			if(score > choice[0]):
				choice = [score, x[0]]

	var current_score = calc(knowledge)
	if(choice[0] * 0.5 > current_score):
		var new_goal = choice[1].new()
		new_goal.init(pawn)
		return new_goal
	else:
		return self

static func target_goals() -> Array:
	var scripts: Array = [
		load("res://characters/state/ai/goals/kill_goal.gd"),
		load("res://characters/state/ai/goals/talk_goal.gd"),
	]
	var goals: Array = []
	for x in scripts:
		goals.push_back([x, funcref(x, "calc")])
	return goals

static func goals() -> Array:
	var scripts: Array = [
		load("res://characters/state/ai/goals/patrol_goal.gd"),
		load("res://characters/state/ai/goal.gd"),
	]
	var goals: Array = []
	for x in scripts:
		goals.push_back([x, funcref(x, "calc")])
	return goals

static func actions() -> Array:
	var scripts: Array = [
		load("res://characters/state/ai/actions/interact_action.gd"),
		load("res://characters/state/ai/actions/walk_action.gd"),
		load("res://characters/state/ai/actions/sprint_action.gd"),
		load("res://characters/state/ai/actions/run_action.gd"),
	]
	var actions: Array = []
	for x in scripts:
		actions.push_back(x)
	return actions
