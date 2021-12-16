class_name ai_mind

var pawn: character

enum body_type {
	unknown = 0,

	ally   = 0x1 << 1,
	enemy  = 0x1 << 2,
	other  = 0x1 << 3, # characters neither ally nor enemy
	object = 0x1 << 4,

	all    = 0xFF
}

const TIME_UNTIL_FORGOTTON: float = 30.0

class sight_event:
	var body: Spatial
	var type: int
	var last_seen: Vector3
	var out_of_sight_time: float = 0.0
	var in_cone: bool

	func _init(new_body: Spatial, new_type: int, new_last_seen: Vector3, new_out_of_sight_time: float, new_in_cone: bool):
		body = new_body
		type = new_type
		last_seen = new_last_seen
		out_of_sight_time = new_out_of_sight_time
		in_cone = new_in_cone

	func is_in_sight() -> bool:
		return out_of_sight_time <= 0.0

var sight_events: Array = []

func _init(new_pawn: KinematicBody):
	pawn = new_pawn

func process_mind(delta: float):
	var i: int = 0
	while i < sight_events.size():
		if(sight_events[i].in_cone && _check_in_sight(sight_events[i].body)):
			if(!sight_events[i].is_in_sight()):
				pawn.ai.should_reconsider = true
			sight_events[i].out_of_sight_time = 0.0
		else:
			if(sight_events[i].is_in_sight()):
				sight_events[i].last_seen = sight_events[i].body.global_transform.origin
			sight_events[i].out_of_sight_time += delta
			if(!sight_events[i].in_cone && sight_events[i].out_of_sight_time > TIME_UNTIL_FORGOTTON):
				sight_events.remove(i)
				continue
		i += 1

func _check_in_sight(target_body: Spatial) -> bool:
	var result: Dictionary = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_head(), target_body.global_transform.origin)
	if(!result || result["collider"] != target_body):
		if(target_body is character):
			result = pawn.get_world().direct_space_state.intersect_ray(pawn.global_body_head(), target_body.global_body_head())
			if(!result || result["collider"] != target_body):
				return false
		else:
			return false
	return true

func get_latest(target_type: int) -> Spatial:
	var best_body: Spatial = null
	var best_time: float = INF
	for x in sight_events:
		if(x.type & target_type):
			if(x.is_in_sight()):
				return x.body
			if(x.out_of_sight_time < best_time):
				best_body = x.body
	return best_body

func get_nearest(target_type: int) -> Spatial: # TODO: return only objects in sight
	var min_dist: float = INF
	var nearest_target: Spatial = null
	for x in sight_events:
		if(!(x.type & target_type)):
			continue
		var distance = pawn.global_transform.origin.distance_squared_to(x.body.global_transform.origin)
		if(distance < min_dist):
			min_dist = distance
			nearest_target = x.body
	return nearest_target

func get_any(target_type: int) -> Spatial:
	return get_latest(target_type)

func get_most_damaged(target_type: int) -> Spatial:
	var max_pain: float = 0.0
	var most_damaged_target: Spatial = null
	for x in sight_events:
		if(!(x.type & target_type)):
			continue
		var pain = x.body.stats.pain_percentage()
		if(pain > max_pain):
			max_pain = pain
			most_damaged_target = x.body
	return most_damaged_target

func is_in_sight(target_body: Spatial) -> bool:
	for x in sight_events:
		if(x.body == target_body):
			return x.out_of_sight_time == 0.0
	return false

func is_in_sight_by_id(character_id: String) -> bool:
	for x in sight_events:
		if(x.body.name == character_id):
			return x.out_of_sight_time == 0.0
	return false

func is_any_in_sight(target_type: int) -> bool:
	for x in sight_events:
		if(x.type & target_type && x.is_in_sight()):
			return true
	return false

func is_any_out_of_sight(target_type: int) -> bool:
	for x in sight_events:
		if(x.type & target_type && !x.is_in_sight()):
			return true
	return false

func is_any(target_type: int) -> bool:
	for x in sight_events:
		if(x.type & target_type):
			return true
	return false

func _get_body_type(body: Spatial) -> int:
	if(body as character):
		match pawn.dialogue.get_relation(body.name):
			dialogue_state.relation.ally:
				return body_type.ally
			dialogue_state.relation.enemy:
				return body_type.enemy
			_:
				return body_type.other
	elif(body.has_method("interact")):
		return body_type.object
	return body_type.unknown

func register_in_cone(body: Spatial):
	errors.debug_assert(body != null, "body for in_sight shouldn't be null: " + pawn.name)

	var new_type: int = _get_body_type(body)
	if(new_type < 0):
		return
	pawn.ai.should_reconsider = true
	for x in sight_events:
		if(x.body == body):
			x.in_cone = true
			return
	sight_events.push_back(sight_event.new(body, new_type, body.global_transform.origin, 0.0, true))

func unregister_in_cone(body: Spatial):
	errors.debug_assert(body != null, "body for out_of_sight shouldn't be null: " + pawn.name)
	for x in sight_events:
		if(x.body == body):
			x.in_cone = false
			pawn.ai.should_reconsider = true
			break
