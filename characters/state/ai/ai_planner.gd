extends Node

class_name ai_planner

enum value {
	pain = 0,
	focus,
	stamina,
	shield,

	SIZE
}
enum flag {
	enemy_in_sight = 0,
	enemy_in_near,
	enemy_damaged,
	ally_in_sight,
	ally_in_near,
	ally_damaged,
	talking,
	facing_target,

	SIZE
}

class knowledge:
	var values: Array
	var flags: Array

	func _init(new_pain: float=0.0, new_focus: float=0.0, new_stamina: float=0.0, new_shield: float=0.0, bool_mask: int=0):
		values.resize(value.SIZE)
		values[value.pain] = new_pain
		values[value.focus] = new_focus
		values[value.stamina] = new_stamina
		values[value.shield] = new_shield
		flags.resize(flag.SIZE)
		flags[flag.enemy_in_sight] = bool(bool_mask & knowledge_mask.enemy_in_sight)
		flags[flag.enemy_in_near] = bool(bool_mask & knowledge_mask.enemy_in_near)
		flags[flag.enemy_damaged] = bool(bool_mask & knowledge_mask.enemy_damaged)
		flags[flag.ally_in_sight] = bool(bool_mask & knowledge_mask.ally_in_sight)
		flags[flag.ally_in_near] = bool(bool_mask & knowledge_mask.ally_in_near)
		flags[flag.ally_damaged] = bool(bool_mask & knowledge_mask.ally_damaged)
		flags[flag.talking] = bool(bool_mask & knowledge_mask.talking)
		flags[flag.facing_target] = bool(bool_mask & knowledge_mask.facing_target)

	func duplicate() -> knowledge:
		var know: knowledge = knowledge.new()
		know.values = values.duplicate()
		know.flags = flags.duplicate()
		return know

enum knowledge_mask {
	enemy_in_sight	= 1 << flag.enemy_in_near,
	enemy_in_near	= 1 << flag.enemy_in_near,
	enemy_damaged	= 1 << flag.enemy_damaged,
	ally_in_sight	= 1 << flag.ally_in_sight,
	ally_in_near	= 1 << flag.ally_in_near,
	ally_damaged	= 1 << flag.ally_damaged,
	talking			= 1 << flag.talking,
	facing_target	= 1 << flag.facing_target,

	pain			= 1 << (value.pain + flag.SIZE),
	focus			= 1 << (value.focus + flag.SIZE),
	stamina			= 1 << (value.stamina + flag.SIZE),
	shield			= 1 << (value.shield + flag.SIZE),
	pain_toggle		= 1 << (value.pain + flag.SIZE + value.SIZE), # if set in precondition, pain has to be lower; if set in postcondition, pain is absolute
	focus_toggle	= 1 << (value.focus + flag.SIZE + value.SIZE),
	stamina_toggle	= 1 << (value.stamina + flag.SIZE + value.SIZE),
	shield_toggle	= 1 << (value.shield + flag.SIZE + value.SIZE),

	lock			= 1 << 63,
	ALL				= 0x7FFFFFFFFFFFFFFF
}

class goal:
	var requirements: knowledge
	var mask: int

	func _init(new_requirements: knowledge, new_mask: int):
		requirements = new_requirements
		mask = new_mask

var planning_graph: Array # contains all a_star_node instances; index of node equals position in array
var current_goals: Array # currently pursued goals, sorted by priority
var current_actions: Array # currently available actions

func plan(know: knowledge, goals: Array, actions: Array) -> Array:
	current_goals = goals
	current_actions = actions
	build_graph(know)
	var action_plan: Array
	for i in range(goals.size()):
		# todo: better looping over goal nodes, currently depending on order of nodes in planning_graph - requires all goals at the end; also: implement priority
		if(action_plan.empty()):
			action_plan = a_star_path_to_actions(a_star(planning_graph.front(), get_graph_node(actions.size() + i + 1)))
		else:
			break
	return action_plan

func build_graph(know: knowledge):
	planning_graph.clear()
	planning_graph.push_back(a_star_node.from_knowledge(know, -1, 0))
	for i in current_actions.size():
		planning_graph.push_back(a_star_node.from_action(current_actions[i], i, planning_graph.size()))
	for x in current_goals: # todo: graph only for current_goals or all goals?
		planning_graph.push_back(a_star_node.from_goal(x, -1, planning_graph.size()))

class a_star_node:
	var id: int # -1 if no action
	var index: int
	var before: knowledge
	var before_mask: int
	var after: knowledge
	var after_mask: int
	var cost: float

	func _init(new_id: int, new_index: int, new_before: knowledge, new_before_mask: int, new_after: knowledge, new_after_mask: int, new_cost: int):
		id = new_id
		index = new_index
		before = new_before
		before_mask = new_before_mask
		after = new_after
		after_mask = new_after_mask
		cost = new_cost

	func before_satisfied(know: knowledge) -> bool:
		if(before_mask & knowledge_mask.lock):
			return false
		for i in range(know.values.size()):
			if(before_mask & (1 << (i + flag.SIZE))):
				if(before_mask & (1 << (i + flag.SIZE + value.SIZE))):
					if(before.values[i] > know.values[i]):
						return false
				else:
					if(before.values[i] < know.values[i]):
						return false
		for i in range(know.flags.size()):
			if(before_mask & (1 << i)):
				if(before.flags[i] != know.flags[i]):
					return false
		return true

	func apply_after(know: knowledge) -> knowledge:
		var new_know = know.duplicate()
		for i in range(know.values.size()):
			if(after_mask & (1 << (i + flag.SIZE))):
				if(after_mask & (1 << (i + flag.SIZE + value.SIZE))):
					new_know.values[i] = after.values[i]
				else:
					new_know.values[i] = max(know.values[i] + after.values[i], 0) # todo: limit to max
		for i in range(know.flags.size()):
			if(after_mask & (1 << i)):
				new_know.flags[i] = after.flags[i]
		return new_know

	static func from_action(action_class: Reference, new_id: int, new_index: int) -> a_star_node:
		# todo: (performance) remove need to create instance
		var temp_action = action_class.new()
		return a_star_node.new(new_id, new_index, temp_action.precondition(), temp_action.precondition_mask(), temp_action.postcondition(), temp_action.postcondition_mask(), temp_action.cost())

	static func from_knowledge(know: knowledge, new_id: int, new_index: int) -> a_star_node:
		return a_star_node.new(new_id, new_index, knowledge.new(), knowledge_mask.ALL | knowledge_mask.lock, know, knowledge_mask.ALL, 0)

	static func from_goal(g: goal, new_id: int, new_index: int):
		return a_star_node.new(new_id, new_index, g.requirements, g.mask, knowledge.new(), knowledge_mask.ALL | knowledge_mask.lock, 0)

func get_graph_node(index: int):
	return planning_graph[index]

func get_graph_index(node: a_star_node):
	return node.index

func heuristic_by_index(_index: int) -> float:
	return 0.0

func weight(_from: a_star_node, to: a_star_node) -> float:
	return to.cost

func weight_by_index(from: int, to: int) -> float:
	return weight(get_graph_node(from), get_graph_node(to))

func get_graph_neighbors(know: knowledge) -> Array:
	var neighbors: Array = []
	for x in planning_graph:
		if(x.before_satisfied(know)):
			neighbors.push_back(x.index)
	return neighbors

func a_star(start: a_star_node, end: a_star_node) -> Array:
	var start_index = get_graph_index(start)
	var end_index = get_graph_index(end)
	var discovered: Array = [start_index]
	var predecessors: Dictionary = {} # TODO: allow loops
	var costs: Dictionary = {start_index: 0}
	var costs_over: Dictionary = {start_index: heuristic_by_index(start_index)}
	var state_after: Dictionary = {start_index: start.after}

	while !discovered.empty():
		var current: int = discovered.pop_back()
		if(current == end_index):
			return a_star_path(predecessors, current)
		var current_node: a_star_node = get_graph_node(current)
		if(current_node.after_mask & knowledge_mask.lock):
			continue # skip neighbors if current is goal
		state_after[current] = current_node.apply_after(state_after[predecessors.get(current, start_index)])
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
	var scripts = current_actions
	for x in path:
		if(x.id >= 0):
			var new_action = scripts[x.id].new()
			new_action.init($"..".pawn) # todo: refactor $".."
			action_list.push_back(new_action)
	return action_list
