class_name ai_mind

var pawn: character

enum type {
	ally,
	enemy,
	other, # characters neither ally nor enemy
	object
}

var in_sight_by_type: Array = [[], [], [], []]
var out_of_sight_by_type: Array = [[], [], [], []]

func _init(new_pawn: KinematicBody):
	pawn = new_pawn

func update():
	var all: Array
	for x in in_sight_by_type:
		all.push_back(x.duplicate())
	in_sight_by_type = [[], [], [], []]
	for a in all:
		for x in a:
			in_sight(x)
	all = out_of_sight_by_type.duplicate()
	flush_out_of_sight()
	for a in all:
		for x in a:
			out_of_sight(x)

func flush_out_of_sight():
	out_of_sight_by_type = [[], [], [], []]

func get_nearest(nearest_type: int) -> Spatial: # TODO: return objects
	var min_dist: float = INF
	var nearest_target: Spatial = null
	for x in in_sight_by_type[nearest_type]:
		var distance = pawn.global_transform.origin.distance_squared_to(x.global_transform.origin)
		if(distance < min_dist):
			min_dist = distance
			nearest_target = x
	# todo? use out of sight as well?
	return nearest_target

func get_any(any_type: int) -> Spatial:
	if(in_sight_by_type[any_type].empty()):
		if(out_of_sight_by_type[any_type].empty()):
			return null
		return out_of_sight_by_type[any_type].back()
	return in_sight_by_type[any_type].front()

func get_most_damaged(damaged_type: int) -> Spatial:
	var max_pain: float = 0.0
	var most_damaged_target: Spatial = null
	for x in in_sight_by_type[damaged_type]:
		var pain = x.stats.pain_percentage()
		if(pain > max_pain):
			max_pain = pain
			most_damaged_target = x
	return most_damaged_target

func is_in_sight(body: Spatial) -> bool:
	for x in in_sight_by_type:
		if(x.has(body)):
			return true
	return false

func is_in_sight_by_id(character_id: String) -> bool:
	for t in [type.ally, type.enemy, type.other]:
		for x in in_sight_by_type[t]:
			if(x.name == character_id):
				return true
	return false

func is_any_in_sight(by_type: int) -> bool:
	return !in_sight_by_type[by_type].empty()

func is_any_out_of_sight(by_type: int) -> bool:
	return !out_of_sight_by_type[by_type].empty()

func in_sight(body: Spatial):
	errors.debug_assert(body != null, "body for in_sight shouldn't be null: " + pawn.name)
	var new_type: int = -1
	if(body as character):
		match pawn.dialogue.get_relation(body.name):
			dialogue_state.relation.ally:
				new_type = type.ally
			dialogue_state.relation.enemy:
				new_type = type.enemy
			_:
				new_type = type.other
	elif(body.has_method("interact")):
		new_type = type.object

	if(new_type < 0):
		return
	if(out_of_sight_by_type[new_type].has(body)):
		out_of_sight_by_type[new_type].erase(body)
	in_sight_by_type[new_type].push_back(body)

func out_of_sight(body: Spatial):
	errors.debug_assert(body != null, "body for out_of_sight shouldn't be null: " + pawn.name)
	for t in type.values():
		if(in_sight_by_type[t].has(body)):
			in_sight_by_type[t].erase(body)
			out_of_sight_by_type[t].push_back(body)
			break
