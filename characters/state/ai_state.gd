extends Node

class_name ai_state

onready var state: Node = get_parent()
onready var pawn: KinematicBody = $"../.."
onready var machine: Node = $"ai_machine"
# warning-ignore:unused_class_variable
onready var move: Node = $"../move"
# warning-ignore:unused_class_variable
onready var stats: Node = $"../stats"
# warning-ignore:unused_class_variable
onready var dialogue: Node = $"../dialogue"

const STEPS_BEFORE_RECONSIDER_DURING_PLAN = 1000
const STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN = 30
var _steps_since_consider: int = 0

var brain: ai_mind
var should_reconsider: bool = false

func _ready():
	if(state.is_player):
		return
	_steps_since_consider = 0

func _process(_delta: float):
	if(state.is_player || (stats.dead && !stats.undead)):
		return
	machine.process_state()
	if(_steps_since_consider == 0):
		brain.flush_out_of_sight()
	_steps_since_consider += 1
	if(machine.action_queue.empty() && _steps_since_consider >= STEPS_BEFORE_RECONSIDER_WITHOUT_PLAN ||
		_steps_since_consider >= STEPS_BEFORE_RECONSIDER_DURING_PLAN):
		should_reconsider = true
	if(should_reconsider):
		machine.push_state(ai_machine.states.idle)
		_steps_since_consider = 0

func get_current_knowledge() -> int:
	var know: int = 0
	if(stats.pain_percentage() > 0.7):
		know |= planner.knowledge.high_pain
	elif(stats.pain_percentage() < 0.2):
		know |= planner.knowledge.low_pain
	if(stats.focus_percentage() > 0.7):
		know |= planner.knowledge.high_focus
	elif(stats.focus_percentage() < 0.2):
		know |= planner.knowledge.low_focus
	if(!brain.enemies_in_sight.empty()):
		know |= planner.knowledge.enemy_in_sight
		know |= planner.knowledge.enemy_in_near
	elif(!brain.enemies_out_of_sight.empty()):
		know |= planner.knowledge.enemy_in_near
	if(!brain.allies_in_sight.empty()):
		know |= planner.knowledge.ally_in_sight
		know |= planner.knowledge.ally_in_near
	elif(!brain.allies_out_of_sight.empty()):
		know |= planner.knowledge.ally_in_near
	var most_damaged = brain.get_most_damaged_enemy()
	if(most_damaged && most_damaged.stats.pain_percentage() > 0.85):
		know |= planner.knowledge.enemy_damaged
	most_damaged = brain.get_most_damaged_ally()
	if(most_damaged && most_damaged.stats.pain_percentage() > 0.7):
		know |= planner.knowledge.ally_damaged
	if(dialogue.is_dialogue_active()):
		know |= planner.knowledge.talking
	return know

func _on_sight_zone_body_entered(body: Node):
	if(state.is_player || body == pawn || !body):
		return
	# todo: repeat cast after some time if fails (might be better in brain to check for everything "in sight" if it is actually visible
	var result: Dictionary = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_head(), body.global_transform.origin)
	if(!result || result["collider"] != body):
		if(body is character):
			result = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_head(), body.global_body_head())
			if(!result || result["collider"] != body):
				return
		else:
			return
	brain.in_sight(body)
	machine.push_state(ai_machine.states.idle)

func _on_sight_zone_body_exited(body: Node):
	if(!body):
		return
	brain.out_of_sight(body)
	machine.push_state(ai_machine.states.idle)

func save(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	#_ai_state["mind"] = brain # todo: add save functionality for brain
	state_dict["ai"] = _ai_state

func init(state_dict: Dictionary):
	var _ai_state = state_dict.get("ai", {})
	brain = _ai_state.get("mind", ai_mind.new(pawn))
