extends Node

class_name planner

enum knowledge {
	low_pain		= 0x0001,
	high_pain		= 0x0002,
	low_focus		= 0x0004,
	high_focus		= 0x0008,
	enemy_in_sight	= 0x0010,
	enemy_in_near	= 0x0020,
	enemy_damaged	= 0x0040,
	ally_in_sight	= 0x0080,
	ally_in_near	= 0x0100,
	ally_damaged	= 0x0200,
	talking			= 0x0400,
	facing_target	= 0x0800,

	ALL				= 0xFFFF
}

class goal:
	var requirements: int
	var mask: int

	func _init(new_requirements: int, new_mask: int):
		requirements = new_requirements
		mask = new_mask

var goals: Dictionary = {
	"survive":	goal.new(knowledge.low_pain, knowledge.low_pain),
	"fight":	goal.new(knowledge.low_pain | knowledge.enemy_damaged, knowledge.low_pain | knowledge.enemy_damaged),
	"talk":		goal.new(knowledge.talking, knowledge.talking),
	"patrol":	goal.new(knowledge.low_pain | knowledge.enemy_in_sight, knowledge.low_pain | knowledge.enemy_in_sight),
}

enum actions {
	talk_begin = 0,
	rotate,
	cast_slot0,
	heal,
	wait,
}

var planning_graph: Array # contains all a_star_node instances; index of node equals position in array
var current_goals: Array # currently pursued goals, sorted by priority

func plan(know: int) -> Array:
	update_goals()
	build_graph(know)
	var action_plan: Array
	for i in range(current_goals.size()):
		# todo: better looping over goal nodes, currently depending on order of nodes in planning_graph - requires all goals at the end; also: implement priority
		if(action_plan.empty()):
			action_plan = a_star_path_to_actions(a_star(planning_graph.front(), get_graph_node(actions.size() + i + 1)))
		else:
			break
	return action_plan

func update_goals():
	current_goals.clear()
	for x in goals.values():
		current_goals.push_back(x)

func build_graph(know: int):
	planning_graph.clear()
	planning_graph.push_back(a_star_node.from_knowledge(know, -1, 0))
	var action_scripts = action_scripts()
	for x in actions.values():
		planning_graph.push_back(a_star_node.from_action(action_scripts[x], x, planning_graph.size()))
	for x in current_goals: # todo: graph only for current_goals or all goals?
		planning_graph.push_back(a_star_node.from_goal(x, -1, planning_graph.size()))

class a_star_node:
	var id: int # -1 if no action
	var index: int
	var before: int
	var before_mask: int
	var after: int
	var after_mask: int
	var cost: float

	func _init(new_id: int, new_index: int, new_before: int, new_before_mask: int, new_after: int, new_after_mask: int, new_cost: int):
		id = new_id
		index = new_index
		before = new_before
		before_mask = new_before_mask
		after = new_after
		after_mask = new_after_mask
		cost = new_cost

	func before_masked() -> int:
		return before & before_mask

	func after_masked() -> int:
		return after & after_mask

	func before_satisfied(know: int) -> bool:
		return before_masked() == (know & before_mask)

	func apply_after(know: int) -> int:
		return (know & ~after_mask) | (after & after_mask)

	static func from_action(action_class: Reference, new_id: int, new_index: int) -> a_star_node:
		# todo: (performance) remove need to create instance
		var temp_action = action_class.new()
		return a_star_node.new(new_id, new_index, temp_action.precondition(), temp_action.precondition_mask(), temp_action.postcondition(), temp_action.postcondition_mask(), temp_action.cost())

	static func from_knowledge(know: int, new_id: int, new_index: int) -> a_star_node:
		return a_star_node.new(new_id, new_index, 0, knowledge.ALL, know, knowledge.ALL, 0)

	static func from_goal(g: goal, new_id: int, new_index: int):
		return a_star_node.new(new_id, new_index, g.requirements, g.mask, 0, knowledge.ALL, 0)

func get_graph_node(index: int):
	return planning_graph[index]

func get_graph_index(node: a_star_node):
	return node.index

func heuristic_by_index(_index: int) -> float:
	return 0.0

func weight(from: a_star_node, to: a_star_node) -> float:
	return from.cost + to.cost

func weight_by_index(from: int, to: int) -> float:
	return weight(get_graph_node(from), get_graph_node(to))

func get_graph_neighbors(know: int) -> Array:
	var neighbors: Array = []
	for x in planning_graph:
		if(x.before_satisfied(know)):
			neighbors.push_back(x.index)
	return neighbors

func a_star(start: a_star_node, end: a_star_node) -> Array:
	var start_index = get_graph_index(start)
	var end_index = get_graph_index(end)
	var discovered: Array = [start_index]
	var predecessors: Dictionary = {}
	var costs: Dictionary = {start_index: 0}
	var costs_over: Dictionary = {start_index: heuristic_by_index(start_index)}
	var state_after: Dictionary = {start_index: start.after}

	while !discovered.empty():
		var current: int = discovered.back()
		var current_after_state = get_graph_node(current).apply_after(state_after[predecessors.get(current, start_index)])
		state_after[current] = current_after_state
		if(current == end_index):
			return a_star_path(predecessors, current)
		discovered.pop_back()
		for x in get_graph_neighbors(state_after[current]):
			var new_score = costs[current] + weight_by_index(current, x)
			if(new_score < costs.get(x, INF)):
				predecessors[x] = current
				costs[x] = new_score
				costs_over[x] = new_score + heuristic_by_index(x)
				if(!discovered.has(x)):
					var i: int = 0
					while i < discovered.size():
						if(costs_over[discovered[i]] < costs_over.get(x, INF)):
							discovered.insert(i, x)
							break
						i += 1
					if(i == discovered.size()):
						discovered.push_back(x)
	return []

func a_star_path(predecessors: Dictionary, last: int) -> Array:
	var path: Array = [get_graph_node(last)]
	while predecessors.has(last):
		last = predecessors[last]
		path.push_front(get_graph_node(last))
	return path

func a_star_path_to_actions(path: Array) -> Array:
	var action_list = []
	var scripts = action_scripts()
	for x in path:
		if(x.id >= 0):
			var new_action = scripts[x.id].new()
			new_action.init($"..".pawn) # todo: refactor $".."
			action_list.push_back(new_action)
	return action_list

static func action_scripts() -> Array:
	var scripts = []
	for x in actions:
		scripts.push_back(load("res://characters/state/ai/actions/" + x + "_action.gd"))
	return scripts
