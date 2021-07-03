extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var character: KinematicBody = $"../.."
onready var skills: Node = $"../skills"
onready var stats: Node = $"../stats"
onready var dialogue: Node = $"../dialogue"

var current_goal: Array = [-INF]
var action_queue: Array

var characters_in_sight: Array = []

var target_goals = [
	"attack",
	"talk",
]

var goals = [
	"wait",
	"patrol",
]

var actions = [
	"move",
	"interact",
]

func wait():
	action_queue.push_back(["wait", [["wait_time", 100000]]])

func patrol():
	pass

func attack(target: character):
	skills.cast_slot(0)
	wait()

func talk(target: character):
	action_queue.push_back(["move_to", [["location", target.translation]]])

func calc_wait() -> float:
	return 0.0

func calc_patrol() -> float:
	return 5 * float(dialogue.job == "guard")

func calc_attack() -> float:
	return (1 - knowledge["pain"]) * knowledge["focus"] * 10 - knowledge["relationship"]

func calc_talk() -> float:
	return knowledge["relationship"] / 10 + 1

var knowledge = {
	"pain": 0,
	"focus": 0,
	"stamina": 0,
	"relationship": 0,
}

func update_knowledge(target: character):
	knowledge["pain"] = stats.pain
	knowledge["focus"] = stats.focus
	knowledge["stamina"] = stats.stamina
	if(target):
		knowledge["relationship"] = dialogue.get_relationship(target.name)

func update_goal(target:character=null):
	update_knowledge(target)
	var scores: Array
	var choice = current_goal
	for x in goals:
		scores.push_back(call("calc_" + x))
		if(choice[0] < scores.back()):
			choice = [scores.back(), x]
	if(target):
		for x in target_goals:
			scores.push_back(call("calc_" + x))
			if(choice[0] < scores.back()):
				choice = [scores.back(), x, target]

	if(choice[0] / 2 > current_goal[0]):
		action_queue.clear()
		if(_current_task):
			_current_task.cancel()
	current_goal = choice
	if(current_goal.size() <= 2):
		call(current_goal[1])
	else:
		call(current_goal[1], current_goal[2])

var _current_task: task
func start_next_task():
	var next_task = action_queue.pop_front()
	_current_task = load("res://characters/state/ai/tasks/" + next_task[0] + ".gd").new()
	for x in next_task[1]:
		_current_task.set(x[0], x[1])
	_current_task.start(character)

func run_action_for_goal(delta: float):
	if(_current_task.run(delta) != task.task_status.RUNNING):
		start_next_task()
		if(action_queue.empty()):
			update_goal()

func _ready():
	if(state.is_player):
		return
	update_goal()
	start_next_task()

func _process(delta: float):
	if(state.is_player || current_goal.size() < 2):
		return
	run_action_for_goal(delta)


func _on_sight_zone_body_entered(body: Node):
	if(state.is_player):
		return
	if(body as character && body != character):
		characters_in_sight.push_back(body)
		update_goal(body)

func _on_sight_zone_body_exited(body: Node):
	if(characters_in_sight.has(body)):
		characters_in_sight.erase(body)
		update_goal()
