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
var steps_since_idle: int = 0 # todo: remove/adjust - little hack to increase performance; only call idle() if a random amount of steps passed since last idle
var steps_to_wait_before_idle: int = randi() % 10 + 1 # todo: adjust

func process_state():
	steps_since_idle += 1
	match state_queue.pop_front():
		states.idle:
			#if(steps_since_idle < steps_to_wait_before_idle):
			#	return
			idle()
			steps_since_idle = 0
		states.move:
			move()
		states.active:
			active()
		# todo: necessary?
		#null:
		#	push_state(states.idle)

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
	if(!ai.brain.enemies_in_sight.empty()):
		know |= planner.knowledge.enemy_in_sight
		know |= planner.knowledge.enemy_in_near
	elif(!ai.brain.enemies_out_of_sight.empty()):
		know |= planner.knowledge.enemy_in_near
	if(!ai.brain.allies_in_sight.empty()):
		know |= planner.knowledge.ally_in_sight
		know |= planner.knowledge.ally_in_near
	elif(!ai.brain.allies_out_of_sight.empty()):
		know |= planner.knowledge.ally_in_near
	var most_damaged = ai.brain.get_most_damaged_enemy()
	if(most_damaged && most_damaged.stats.pain_percentage() > 0.85):
		know |= planner.knowledge.enemy_damaged
	most_damaged = ai.brain.get_most_damaged_ally()
	if(most_damaged && most_damaged.stats.pain_percentage() > 0.7):
		know |= planner.knowledge.ally_damaged
	if(ai.dialogue.is_dialogue_active()):
		know |= planner.knowledge.talking
	return know

func reconsider():
	consider(get_current_knowledge())

func consider(know: int):
	action_queue = planning.plan(know)
	if(action_queue.empty()):
		pass
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
	var nav = game.levels.current_level.get_node("navigation")
	var destination = current_action.target.global_transform.origin
	if(nav):
		var path: PoolVector3Array = nav.get_simple_path(ai.pawn.global_transform.origin, destination)
		if(!path.empty()):
			ai.pawn.look_at(Vector3(path[1].x, ai.pawn.global_transform.origin.y, path[1].z), Vector3.UP)
			ai.pawn.move.input_direction = Vector3.FORWARD
			# TODO: push move or active; but: current_action somehow null
			push_state(states.active)

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
		ai.pawn.move.input_direction = Vector3.ZERO
		if(!current_action.do()):
			# todo? plan failed/aborted
			push_state(states.idle)
		action_queue.pop_front()
	else:
		push_state(states.move)
