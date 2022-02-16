extends abstract_action

const IMPORTANCE: float = 0.95

static func _spell_id() -> String:
	return platform_spell.id()

static func score(pawn: KinematicBody) -> Dictionary:
	var score: float = 0.0
	if(pawn.skills.can_cast(_spell_id())):
		var fall_score: float = clamp(-pawn.move.velocity.y / 10, 0, 1)
		pawn.ray.set_cast_to(Vector3.DOWN * 10.0)
		pawn.ray.force_raycast_update()
		var result: Vector3 = pawn.ray.get_collision_point()
		var ground_score: float = pawn.global_transform.origin.distance_squared_to(result) / 100
		score = clamp(fall_score * ground_score, 0, 1) * IMPORTANCE
	return {
		"score": score
	}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	pawn.skills.cast_spell(_spell_id())
	return do_state.success
