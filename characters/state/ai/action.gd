class_name abstract_action

enum range_state {
	no_range_required,
	in_range,
	out_of_range,
	unreachable
}

enum do_state {
	success,
	failure,
	repeat
}

var pawn: KinematicBody
var target: Spatial

func init(new_pawn: KinematicBody):
	pawn = new_pawn
	choose_target()

### override functions below

# todo: allow multiple preconditions
static func precondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func postcondition() -> ai_planner.knowledge:
	return ai_planner.knowledge.new()

static func precondition_mask() -> int:
	return ai_planner.knowledge_mask.ALL

static func postcondition_mask() -> int:
	return ai_planner.knowledge_mask.ALL

static func cost() -> float:
	return 1.0

func choose_target():
	target = null

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	return do_state.success
