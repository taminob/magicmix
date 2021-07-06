class_name action

enum range_state {
	no_range_required,
	in_range,
	out_of_range,
}

var pawn: character
var target: Spatial

# todo: remove new_pawn default argument
func init(new_pawn: character=null, new_target: Spatial=null):
	pawn = new_pawn
	target = new_target

static func precondition() -> int:
	return 0

static func postcondition() -> int:
	return 0

static func cost() -> float:
	return 1.0

func get_range_state() -> int:
	return range_state.no_range_required

func do():
	pass
