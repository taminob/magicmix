extends Node

class_name ai_machine

enum states {
	idle,
	move,
	active,
}

onready var ai: Node = $".."
onready var planning: planner = $"../planner"
var state_queue: Array = []
var action_queue: Array = []

func process_state():
	match state_queue.pop_front():
		states.idle:
			idle()
		states.move:
			move()
		states.active:
			active()
		null:
			push_state(states.idle)

func push_state(new_state: int):
	# todo: good idea?
	if(new_state == states.idle && !state_queue.empty() && state_queue.back() == new_state):
		return
	state_queue.push_back(new_state)

func get_current_knowledge():
	var know: int = 0
	if(ai.stats.pain_percentage() > 0.7):
		know |= planner.knowledge.high_pain
	elif(ai.stats.pain_percentage() < 0.2):
		know |= planner.knowledge.low_pain
	if(ai.stats.focus_percentage() > 0.7):
		know |= planner.knowledge.high_focus
	elif(ai.stats.focus_percentage() < 0.2):
		know |= planner.knowledge.low_focus
	for x in ai.characters_in_sight:
		match ai.character.dialogue.get_relation(x.name):
			dialogue_state.relation.ally:
				if(x.stats.pain_percentage() < 0.3):
					know |= planner.knowledge.ally_damaged
				know |= planner.knowledge.ally_in_sight
			dialogue_state.relation.enemy:
				if(x.stats.pain_percentage() < 0.3):
					know |= planner.knowledge.enemy_damaged
				know |= planner.knowledge.enemy_in_sight
	return know

func reconsider():
	consider(get_current_knowledge())

func consider(know: int):
	action_queue = planning.plan(know)
	if(action_queue.empty()):
		push_state(states.idle)
	else:
		push_state(states.active)

func idle():
	reconsider()

func move():
	ai.move.current_mode = move_state.move_mode.RUNNING # todo: implement other move modes
	var current_action = action_queue.front()
	var nav = game.levels.current_level.get_node("navigation")
	var destination = current_action.location
	if(nav):
		var path: PoolVector3Array = nav.get_simple_path(ai.character.global_transform.origin, destination)
		if(!path.empty()):
			ai.character.look_at(Vector3(path[1].x, ai.character.global_transform.origin.y, path[1].z), Vector3.UP)
			ai.character.move.input_direction = Vector3.FORWARD

func active():
	if(action_queue.empty()):
		push_state(states.idle)
		return
	var current_action = action_queue.front()
	#todo: remove?
	#if(current_action.fulfilled()):
	#	action_queue.pop_front()
	#	active()
	#	return
	var action_range = current_action.get_range_state()
	if(action_range == action.range_state.in_range || action_range == action.range_state.no_range_required):
		if(!current_action.do()):
			push_state(states.idle)
		action_queue.pop_front() # todo: here correct?
	else:
		push_state(states.move)
