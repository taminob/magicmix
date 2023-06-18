extends abstract_action

const IMPORTANCE: float = 0.8

static func _spell_id() -> String:
	return invert_gravity_spell.id()

static func score(pawn: CharacterBody3D) -> Dictionary:
	var score: float = 0.0
	if(pawn.skills.can_cast(_spell_id())):
		var fall_score: float = clamp(-pawn.move.velocity.y / 10, 0, 1)
		pawn.ray.set_target_position(Vector3.UP * 20.0)
		pawn.ray.force_raycast_update()
		var result: Object = pawn.ray.get_collider()
		if(!result):
			var distance_score: float = 0.0
			var spawn: Node3D = game.levels.get_spawn(pawn.name)
			if(spawn):
				distance_score = (spawn.global_transform.origin.y - pawn.global_transform.origin.y) / 10.0
			else:
				distance_score = -pawn.global_transform.origin.y / 10.0
			score = clamp(fall_score * distance_score, 0, 1) * IMPORTANCE
	return {
		"score": score
	}

func get_range_state() -> int:
	return range_state.no_range_required

func do(_delta: float) -> int:
	pawn.skills.cast_spell(_spell_id())
	return do_state.success
