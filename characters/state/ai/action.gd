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
var data: Dictionary

func init(new_pawn: KinematicBody, new_data: Dictionary):
	pawn = new_pawn
	data = new_data

func target() -> Spatial:
	return data.get("target", null)

### helpers
static func _distance_score(pawn: KinematicBody, target: Spatial, max_distance: float, exponent: float=2.0) -> float:
	if(max_distance <= 0.0):
		return 1.0
	var dist: float = pawn.global_transform.origin.distance_squared_to(target.global_transform.origin) / (max_distance * max_distance)
	return 1 - pow(min(dist, 1.0), exponent)

static func _rotate_score(pawn: KinematicBody, target: Spatial, exponent: float=1.0):
	return 1 - pow(pawn.global_transform.basis.z.angle_to(pawn.global_transform.origin - target.global_transform.origin) / PI, exponent)

### override functions below
# {score: (worst) 0.0 <-> 1.0 (best)}
static func score(pawn: KinematicBody) -> Dictionary:
	return {"score": 0.0}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	return do_state.success
