extends Node

class_name planner

enum knowledge {
	low_pain		= 0x0001,
	high_pain		= 0x0002,
	low_focus		= 0x0004,
	high_focus		= 0x0008,
	enemy_in_sight	= 0x0010,
	enemy_damaged	= 0x0020,
	ally_in_sight	= 0x0040,
	ally_damaged	= 0x0080,
	talking			= 0x0100,
}

enum goals {
	survive			= knowledge.low_pain,
	fight			= knowledge.low_pain,
	talk			= knowledge.talking,
	patrol			= knowledge.enemy_in_sight,
}

enum actions {
	interact = 0,
	rotate,
	cast_slot0,
	heal,
	wait,
}

var planning_graph: Array # contains all a_star_node instances; index of node equals position in array
var adjacencies: Dictionary # maps before knowledge to array of all nodes which satisfy this knowledge
var current_goals: Array # 
var current_goal: int
var current_goal_index: int

func plan(know: int) -> Array:
	update_goals()
	build_graph(know)
	return a_star_path_to_actions(a_star(planning_graph.front(), get_graph_node(current_goal_index)))

func update_goals():
	current_goals.clear()
	for x in goals.values():
		current_goals.push_back(x)
	current_goal = current_goals.front()

func build_graph(know: int):
	planning_graph.clear()
	adjacencies.clear()
	planning_graph.push_back(a_star_node.from_knowledge(know, -1, 0))
	adjacencies[planning_graph.back().before] = []
	var action_scripts = action_scripts()
	for x in actions.values():
		insert_node(a_star_node.from_action(action_scripts[x], x, planning_graph.size()))
	for x in goals.values():
		if(x == current_goal):
			current_goal_index = planning_graph.size()
		insert_node(a_star_node.from_goal(x, -1, planning_graph.size()))

func insert_node(node: a_star_node):
	planning_graph.push_back(node)
	if(adjacencies.has(node.before)):
		adjacencies[node.before].push_back(node.index)
	else:
		adjacencies[node.before] = [node.index]

class a_star_node:
	var id: int # -1 if no action
	var index: int
	var before: int
	var after: int
	var cost: float

	func _init(new_id: int, new_index: int, new_before: int, new_after: int, new_cost: int):
		id = new_id
		index = new_index
		before = new_before
		after = new_after
		cost = new_cost

	static func from_action(action_class: Reference, id: int, index: int) -> a_star_node:
		# todo: (performance) remove need to create instance
		var temp_action = action_class.new()
		return a_star_node.new(id, index, temp_action.precondition(), temp_action.postcondition(), temp_action.cost())

	static func from_knowledge(know: int, id: int, index: int) -> a_star_node:
		return a_star_node.new(id, index, 0, know, 0)

	static func from_goal(goal: int, id: int, index: int):
		return a_star_node.new(id, index, goal, 0, 0)

func get_graph_node(index: int):
	return planning_graph[index]

func get_graph_index(node: a_star_node):
	return node.index

func heuristic_by_index(index: int) -> float:
	return 1.0

func weight(from: a_star_node, to: a_star_node) -> float:
	return from.cost + to.cost

func weight_by_index(from: int, to: int) -> float:
	return weight(get_graph_node(from), get_graph_node(to))

func get_graph_neighbors(index: int) -> Array:
	return adjacencies.get(get_graph_node(index).after, [])

func a_star(start: a_star_node, end: a_star_node) -> Array:
	var start_index = get_graph_index(start)
	var end_index = get_graph_index(end)
	var discovered: Array = [start_index]
	var predecessors: Dictionary = {}
	var costs: Dictionary = {start_index: 0}
	var costs_over: Dictionary = {start_index: heuristic_by_index(start_index)}

	while !discovered.empty():
		var current: int = discovered.back()
		if(current == end_index):
			return a_star_path(predecessors, current)
		discovered.pop_back()
		var neigh = get_graph_neighbors(current)
		for x in neigh:
			var new_score = costs[current] + weight_by_index(current, x)
			if(new_score < costs.get(x, INF)):
				predecessors[x] = current
				costs[x] = new_score
				costs_over[x] = new_score + heuristic_by_index(x)
				if(!discovered.has(x)):
					if(discovered.empty()):
						discovered.push_back(x)
					else:
						for i in range(discovered.size()):
							if(costs_over[i] < costs_over.get(x, INF)):
								discovered.insert(i, x)
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
			new_action.init($"..".character, game.mgmt.player) # todo: pass real target
			action_list.push_back(new_action)
	return action_list

static func action_scripts() -> Array:
	var scripts = []
	for x in actions:
		scripts.push_back(load("res://characters/state/ai/actions/" + x + "_action.gd"))
	return scripts
