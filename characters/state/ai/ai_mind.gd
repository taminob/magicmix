class_name ai_mind

var pawn: character
var allies_in_sight: Array = []
var allies_out_of_sight: Array = []
var enemies_in_sight: Array = []
var enemies_out_of_sight: Array = []
var characters_in_sight: Array = []
var characters_out_of_sight: Array = [] # other characters
var objects_in_sight: Array = []
var objects_out_of_sight: Array = []

func _init(new_pawn: KinematicBody):
	pawn = new_pawn

func update_characters():
	var all: Array = allies_in_sight + enemies_in_sight + characters_in_sight
	allies_in_sight.clear()
	enemies_in_sight.clear()
	characters_in_sight.clear()
	for x in all:
		in_sight(x)
	all = allies_out_of_sight + enemies_out_of_sight + characters_out_of_sight
	allies_out_of_sight.clear()
	enemies_out_of_sight.clear()
	characters_out_of_sight.clear()
	for x in all:
		out_of_sight(x)


func flush_out_of_sight():
	allies_out_of_sight.clear()
	enemies_out_of_sight.clear()
	characters_out_of_sight.clear()
	objects_out_of_sight.clear()

func get_nearest_enemy() -> character:
	var min_dist: float = INF
	var nearest_target: character = null
	for x in enemies_in_sight:
		var distance = pawn.global_transform.origin.distance_squared_to(x.global_transform.origin)
		if(distance < min_dist):
			min_dist = distance
			nearest_target = x
	# todo? use enemies out of sight as well?
	return nearest_target

func get_nearest_ally() -> character:
	var min_dist: float = INF
	var nearest_target: character = null
	for x in allies_in_sight:
		var distance = pawn.global_transform.origin.distance_squared_to(x.global_transform.origin)
		if(distance < min_dist):
			min_dist = distance
			nearest_target = x
	# todo? use allies out of sight as well?
	return nearest_target

func get_any_enemy() -> character:
	if(enemies_in_sight.empty()):
		if(enemies_out_of_sight.empty()):
			return null
		return enemies_out_of_sight.back()
	return enemies_in_sight.front()

func get_any_ally() -> character:
	if(allies_in_sight.empty()):
		if(allies_out_of_sight.empty()):
			return null
		return allies_out_of_sight.back()
	return allies_in_sight.front()

func get_most_damaged_enemy() -> character:
	var max_pain: float = 0.0
	var most_damaged_target: character = null
	for x in enemies_in_sight:
		var pain = x.stats.pain_percentage()
		if(pain > max_pain):
			max_pain = pain
			most_damaged_target = x
	return most_damaged_target

# todo: refactor (is basically the same as for enemy)
func get_most_damaged_ally() -> character:
	var max_pain: float = 0.0
	var most_damaged_target: character = null
	for x in allies_in_sight:
		var pain = x.stats.pain_percentage()
		if(pain > max_pain):
			max_pain = pain
			most_damaged_target = x
	return most_damaged_target

# todo? refactor? currently depends on pass-by-reference for Array
func _add_in_sight(body: Node, destination: Array, remove_from: Array=[]):
	if(remove_from.has(body)):
		remove_from.erase(body)
	destination.push_back(body)

func in_sight(body: Node):
	if(body as character):
		match pawn.dialogue.get_relation(body.name):
			dialogue_state.relation.ally:
				_add_in_sight(body, allies_in_sight, allies_out_of_sight)
			dialogue_state.relation.enemy:
				_add_in_sight(body, enemies_in_sight, enemies_out_of_sight)
			_:
				_add_in_sight(body, characters_in_sight, characters_out_of_sight)
	elif(body.has_method("interact")):
		_add_in_sight(body, objects_in_sight, objects_out_of_sight)

func out_of_sight(body: Node):
	if(objects_in_sight.has(body)):
		objects_in_sight.erase(body)
		objects_out_of_sight.push_back(body)
	elif(characters_in_sight.has(body)):
		characters_in_sight.erase(body)
		characters_out_of_sight.push_back(body)
	elif(allies_in_sight.has(body)):
		allies_in_sight.erase(body)
		allies_out_of_sight.push_back(body)
	elif(enemies_in_sight.has(body)):
		enemies_in_sight.erase(body)
		enemies_out_of_sight.push_back(body)
