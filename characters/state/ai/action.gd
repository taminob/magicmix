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

func init(new_pawn: KinematicBody):
	pawn = new_pawn

### override functions below
# score: (worst) 0.0 <-> 1.0 (best)
static func score(pawn: KinematicBody):
	return 0.0

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	return do_state.success
