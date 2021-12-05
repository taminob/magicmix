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

func push_state(new_state: int):
	# todo: good idea?
	if(new_state == states.idle && !state_queue.empty() && state_queue.back() == new_state):
		return
	state_queue.push_back(new_state)

func reconsider():
	consider(ai.get_current_knowledge(), ai.get_current_goals(), ai.get_current_actions())

func consider(know: planner.knowledge, goals: Array, actions: Array):
	action_queue = planning.plan(know, goals, actions)
	if(action_queue.empty()):
		action_queue.push_back(ai.get_idle_action())
		push_state(states.active)
		#push_state(states.idle) # todo? necessary?
	else:
		push_state(states.active)

func idle():
	ai.pawn.move.input_direction = Vector3.ZERO
	reconsider()

func move():
	if(action_queue.empty()):
		return
	ai.move.current_mode = move_state.move_mode.RUNNING # todo: implement other move modes
	var current_action = action_queue.front()
	if(!current_action.target):
		return # todo? check why check is necessary
	var nav: Navigation = game.levels.current_level.get_node("navigation")
	var destination = current_action.target.global_transform.origin
	if(nav):
		var path: PoolVector3Array = nav.get_simple_path(ai.pawn.global_transform.origin, destination)
		if(!path.empty()):
			ai.pawn.face_location(path[1])
			ai.pawn.move.input_direction = Vector3.FORWARD
			# TODO: push move or active; but: current_action somehow null
			push_state(states.active)

func active():
	if(action_queue.empty()):
		push_state(states.idle)
		return
	var current_action: abstract_action = action_queue.front()
	var action_range = current_action.get_range_state()
	if(action_range == abstract_action.range_state.in_range || action_range == abstract_action.range_state.no_range_required):
		ai.pawn.move.input_direction = Vector3.ZERO
		if(!current_action.do()):
			# todo? plan failed/aborted
			push_state(states.idle)
			return
		action_queue.pop_front()
		active()
	elif(action_range == abstract_action.range_state.unreachable):
		push_state(states.idle)
	else:
		push_state(states.move)
