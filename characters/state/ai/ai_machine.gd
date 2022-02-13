extends Node

class_name ai_machine

enum states {
	idle,
	move,
	active,
}

onready var ai: Node = $".."
onready var chooser: Node = $"../ai_chooser"
var state_queue: Array = []
var action_queue: Array = []

func process_state(delta: float):
	match state_queue.pop_front():
		states.idle:
			idle()
		states.move:
			move()
		states.active:
			active(delta)

func push_state(new_state: int):
	# todo: good idea?
	if(new_state == states.idle && !state_queue.empty() && state_queue.back() == new_state):
		return
	state_queue.push_back(new_state)

func plan_failed():
	action_queue.clear()
	push_state(states.idle)

func consider():
	action_queue = [] # TODO: get next action
	if(action_queue.empty()):
		action_queue.push_back(ai.behavior.idle_action(ai.pawn))
		push_state(states.active)
		#push_state(states.idle) # todo? necessary?
	else:
		push_state(states.active)

func idle():
	ai.pawn.move.input_direction = Vector3.ZERO
	action_queue.clear()
	action_queue.push_back(chooser.best_action())
	push_state(states.active)

var current_path: PoolVector3Array = []
var current_path_index: int
func move():
	if(action_queue.empty()):
		return
	ai.move.current_mode = move_state.move_mode.RUNNING # todo: implement other move modes
	var current_action = action_queue.front()
	var current_target: Spatial = current_action.target()
	if(!game.is_valid(current_target)):
		return # todo? check why check is necessary
	var nav: Navigation = game.levels.current_level.get_node("navigation")
	var destination = current_target.global_transform.origin
	if(nav):
		if(current_path.empty() || current_path_index >= current_path.size()):
			current_path = nav.get_simple_path(ai.pawn.global_transform.origin, destination)
			current_path_index = 0
		if(!current_path.empty()):
			# todo: add timeout (unreachable)
			var x = ai.pawn.global_transform.origin
			var d = current_path[current_path_index]
			ai.pawn.face_location(current_path[current_path_index])
			if(x - d < Vector3(0.5, INF, 0.5)):
				current_path_index += 1
			ai.pawn.move.input_direction = Vector3.FORWARD
			# TODO: push move or active; but: current_action somehow null
			push_state(states.active)
		else:
			plan_failed()

func active(delta: float):
	if(action_queue.empty()):
		push_state(states.idle)
		return
	var current_action: abstract_action = action_queue.front()
	if(!current_action || !current_action.valid()):
		plan_failed()
	var action_range = current_action.get_range_state()
	if(action_range == abstract_action.range_state.in_range || action_range == abstract_action.range_state.no_range_required):
		ai.pawn.move.input_direction = Vector3.ZERO
		match current_action.do(delta):
			abstract_action.do_state.success:
				action_queue.pop_front()
				push_state(states.active)
			abstract_action.do_state.failure:
				plan_failed()
			abstract_action.do_state.repeat:
				push_state(states.active)
	elif(action_range == abstract_action.range_state.unreachable):
		plan_failed()
	else:
		push_state(states.move)
