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

var pawn: CharacterBody3D
var data: Dictionary

func init(new_pawn: CharacterBody3D, new_data: Dictionary):
	pawn = new_pawn
	data = new_data

func target() -> Node3D:
	return data.get("target", null)

func valid() -> bool:
	return data.has("target") && game.is_valid(target())

### helpers
static func _distance_score(pawn_char: CharacterBody3D, target: Node3D, max_distance: float, exponent: float=2.0) -> float:
	if(max_distance <= 0.0):
		return 1.0
	var dist: float = pawn_char.distance(target) / (max_distance * max_distance)
	return 1 - pow(min(dist, 1.0), exponent)

static func _rotate_score(pawn_char: CharacterBody3D, target: Node3D, exponent: float=1.0):
	return 1 - pow(pawn_char.looking_direction().angle_to(pawn_char.global_transform.origin - target.global_transform.origin) / PI, exponent)

# score for target to be in desired_range with peak of sine at mid of desired_range
static func _distance_range_score(pawn_char: CharacterBody3D, target: Node3D, desired_range: Array, exponent: float=1.0):
	errors.debug_assert(desired_range.size() == 2 && desired_range[0] < desired_range[1], "invalid range for _distance_range_score for pawn " + pawn_char.name)
	var dist: float = pawn_char.distance(target)
	if(dist < desired_range[0] || dist > desired_range[1]):
		return 0.0
	dist -= desired_range[0]
	dist /= desired_range[1] - desired_range[0]
	return pow(sin(dist * PI), exponent)

### override functions below
# {score: (worst) 0.0 <-> 1.0 (best)}
static func score(_pawn: CharacterBody3D) -> Dictionary:
	return {"score": 0.0}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	return do_state.success
