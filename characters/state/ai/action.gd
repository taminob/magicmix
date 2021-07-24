class_name abstract_action

enum range_state {
	no_range_required,
	in_range,
	out_of_range,
}

var pawn: character
var target: Spatial

func init(new_pawn: character):
	pawn = new_pawn
	choose_target()

### override functions below

# todo: allow multiple preconditions
static func precondition() -> planner.knowledge:
	return planner.knowledge.new()

static func postcondition() -> planner.knowledge:
	return planner.knowledge.new()

static func precondition_mask() -> int:
	return planner.knowledge_mask.ALL

static func postcondition_mask() -> int:
	return planner.knowledge_mask.ALL

static func cost() -> float:
	return 1.0

func choose_target():
	target = null

func get_range_state() -> int:
	return range_state.no_range_required

func do() -> bool:
	return true
