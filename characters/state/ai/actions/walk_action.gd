extends action

const MOVE_MODE: int = move_state.move_mode.WALKING

static func precondition(_know: Dictionary) -> float:
	return action.PERFECT_SCORE

static func postcondition(know: Dictionary) -> Dictionary:
	var pawn = know["pawn"]
	var target = know["pawn"]
	var delta = 1/60
	var new_translation = pawn.global_transform.origin
	var new_stamina = pawn.stats.stamina + delta * (pawn.stats.stamina_per_second() - pawn.move.stamina_cost(MOVE_MODE))
	if(target):
		# todo: cache result
		var nav = game.levels.current_level.get_node("navigation")
		if(nav):
			var path: PoolVector3Array = nav.get_simple_path(pawn.global_transform.origin, target.global_transform.origin)
			if(!path.empty()):
				var direction = new_translation.direction_to(Vector3(path[1].x, pawn.global_transform.origin.y, path[1].z))
				new_translation -= delta * direction * pawn.move.max_speed(MOVE_MODE)
		return {
			"translation": new_translation,
			"distance": new_translation.distance_squared_to(target.global_transform.origin),
			"stamina": new_stamina
		}
	else:
		new_translation -= delta * pawn.global_transform.basis.z * pawn.move.max_speed(MOVE_MODE)
		return {
			"translation": new_translation,
			"stamina": new_stamina
		}

func do(_delta: float, know: Dictionary):
	var pawn = know["pawn"]
	var target = know["target"]
	pawn.move.current_mode = MOVE_MODE
	if(target):
		var nav = game.levels.current_level.get_node("navigation")
		if(nav):
			var path: PoolVector3Array = nav.get_simple_path(pawn.global_transform.origin, target.global_transform.origin)
			if(!path.empty()):
				pawn.look_at(Vector3(path[1].x, pawn.global_transform.origin.y, path[1].z), Vector3.UP)
				pawn.move.input_direction = Vector3.FORWARD
	else:
		pawn.move.input_direction = Vector3.FORWARD
