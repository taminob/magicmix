extends Node

class_name planner

class knowledge:
	var pain: float
	var focus: float
	var enemy_in_sight: bool
	var enemy_in_near: bool
	var enemy_damaged: bool
	var ally_in_sight: bool
	var ally_in_near: bool
	var ally_damaged: bool
	var talking: bool
	var facing_target: bool

	func _init(new_pain: float=0.0, new_focus: float=0.0, bool_mask: int=0):
		pain = new_pain
		focus = new_focus
		enemy_in_sight = bool_mask & knowledge_mask.enemy_in_sight
		enemy_in_near = bool_mask & knowledge_mask.enemy_in_near
		enemy_damaged = bool_mask & knowledge_mask.enemy_damaged
		ally_in_sight = bool_mask & knowledge_mask.ally_in_sight
		ally_in_near = bool_mask & knowledge_mask.ally_in_near
		ally_damaged = bool_mask & knowledge_mask.ally_damaged
		talking = bool_mask & knowledge_mask.talking
		facing_target = bool_mask & knowledge_mask.facing_target

	func duplicate() -> knowledge:
		var know: knowledge = knowledge.new()
		know.pain = pain
		know.focus = focus
		know.enemy_in_sight = enemy_in_sight
		know.enemy_in_near = enemy_in_near
		know.enemy_damaged = enemy_damaged
		know.ally_in_sight = ally_in_sight
		know.ally_in_near = ally_in_near
		know.ally_damaged = ally_damaged
		know.talking = talking
		know.facing_target = facing_target
		return know

enum knowledge_mask {
	enemy_in_sight	= 0x00000001,
	enemy_in_near	= 0x00000002,
	enemy_damaged	= 0x00000004,
	ally_in_sight	= 0x00000008,
	ally_in_near	= 0x00000010,
	ally_damaged	= 0x00000020,
	talking			= 0x00000040,
	facing_target	= 0x00000080,
	#_a				= 0x10000000,
	#_b				= 0x20000000,
	#_c				= 0x40000000,
	#_d				= 0x80000000,
	pain			= 0x01000000,
	pain_toggle		= 0x02000000, # if set in precondition, pain has to be lower; if set in postcondition, pain is absolute
	focus			= 0x04000000,
	focus_toggle	= 0x08000000,

	lock			= 0x80000000,
	ALL				= 0x7FFFFFFF
}

class goal:
	var requirements: knowledge
	var mask: int

	func _init(new_requirements: knowledge, new_mask: int):
		requirements = new_requirements
		mask = new_mask

enum actions {
	talk_begin = 0,
	roam,
	rotate,
	flee,
	spell_heal,
	spell_fire_ring,
	spell_fire_ball,
	spell_blood_storm,
#	wait,
}

var planning_graph: Array # contains all a_star_node instances; index of node equals position in array
var current_goals: Array # currently pursued goals, sorted by priority

func plan(know: knowledge, goals: Array) -> Array:
	current_goals = goals
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
	var action_scripts = action_scripts()
	for x in actions.values():
		planning_graph.push_back(a_star_node.from_action(action_scripts[x], x, planning_graph.size()))
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
		if(before_mask & knowledge_mask.pain):
			if(before_mask & knowledge_mask.pain_toggle):
				if(before.pain > know.pain):
					return false
			else:
				if(before.pain < know.pain):
					return false
		if(before_mask & knowledge_mask.focus):
			if(before_mask & knowledge_mask.focus_toggle):
				if(before.focus > know.focus):
					return false
			else:
				if(before.focus < know.focus):
					return false
		if(before_mask & knowledge_mask.enemy_in_sight):
			if(before.enemy_in_sight != know.enemy_in_sight):
				return false
		if(before_mask & knowledge_mask.enemy_in_near):
			if(before.enemy_in_near != know.enemy_in_near):
				return false
		if(before_mask & knowledge_mask.enemy_damaged):
			if(before.enemy_damaged != know.enemy_damaged):
				return false
		if(before_mask & knowledge_mask.ally_in_sight):
			if(before.ally_in_sight != know.ally_in_sight):
				return false
		if(before_mask & knowledge_mask.ally_in_near):
			if(before.ally_in_near != know.ally_in_near):
				return false
		if(before_mask & knowledge_mask.ally_damaged):
			if(before.ally_damaged != know.ally_damaged):
				return false
		if(before_mask & knowledge_mask.talking):
			if(before.talking != know.talking):
				return false
		if(before_mask & knowledge_mask.facing_target):
			if(before.facing_target != know.facing_target):
				return false
		return true

	func apply_after(know: knowledge) -> knowledge:
		var new_know = know.duplicate()
		if(after_mask & knowledge_mask.pain):
			if(after_mask & knowledge_mask.pain_toggle):
				new_know.pain = after.pain
			else:
				new_know.pain = max(know.pain + after.pain, 0) # todo: limit to max_pain
		if(after_mask & knowledge_mask.focus):
			if(after_mask & knowledge_mask.focus_toggle):
				new_know.focus = after.focus
			else:
				new_know.focus = max(know.focus + after.focus, 0) # todo: limit to max_focus
		if(after_mask & knowledge_mask.enemy_in_sight):
			new_know.enemy_in_sight = after.enemy_in_sight
		if(after_mask & knowledge_mask.enemy_in_near):
			new_know.enemy_in_near = after.enemy_in_near
		if(after_mask & knowledge_mask.enemy_damaged):
			new_know.enemy_damaged = after.enemy_damaged
		if(after_mask & knowledge_mask.ally_in_sight):
			new_know.ally_in_sight = after.ally_in_sight
		if(after_mask & knowledge_mask.ally_in_near):
			new_know.ally_in_near = after.ally_in_near
		if(after_mask & knowledge_mask.ally_damaged):
			new_know.ally_damaged = after.ally_damaged
		if(after_mask & knowledge_mask.talking):
			new_know.talking = after.talking
		if(after_mask & knowledge_mask.facing_target):
			new_know.facing_target = after.facing_target
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

func weight(from: a_star_node, to: a_star_node) -> float:
	return from.cost + to.cost

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
	var predecessors: Dictionary = {}
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
