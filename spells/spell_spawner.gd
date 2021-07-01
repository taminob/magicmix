extends Spatial

class_name spell_spawner

var time: float
var amount: int
var spawn_timer: Timer
var radius: float
var spell: Dictionary = {}
var example_object: Area = null
var can_spawn_behind_walls: bool = false
var _objects: Array = []
var _affected_bodies: Array = []
onready var _caster: character = $".."
var _caster_affected: bool = false
var _default_collision_mask: int = game.mgmt.layer.characters  | game.mgmt.layer.enemies | game.mgmt.layer.spells

# override for custom placement; return position
func first_object_position(_object: Area, _object_id: int) -> Vector3:
	return Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1).normalized() * radius

func next_object_position(object: Area, _object_id: int, _object_age: float) -> Vector3:
	return object.translation

func set_example_object(object: Area):
	example_object = object
	_default_collision_mask = example_object.collision_mask

func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.set_one_shot(true)
	errors.error_test(spawn_timer.connect("timeout", self, "spawn_object"))

func _physics_process(delta: float):
	if(!spell || !example_object):
		return
	var i = 0
	while i < _objects.size():
		_objects[i][0] += delta
		if(_objects[i][0] >= time):
			_objects[i][1].queue_free()
			_objects.remove(i)
		else:
			_objects[i][1].translation = next_object_position(_objects[i][1], i, _objects[i][0])
			set_object_active(_objects[i][1], can_reach_caster(_objects[i][1]))
			i += 1

	for x in _affected_bodies:
		x.damage(spells.get_pain(spell, "target", true) * delta)
	if(_caster_affected):
		_caster.damage(spells.get_pain(spell, "self", true) * delta)

func set_object_active(target: Area, active:bool=true):
	target.set_visible(active)
	target.collision_mask = _default_collision_mask if active else 0

func can_reach_caster(target: Area) -> bool:
	if(can_spawn_behind_walls):
		return true
	var result = get_world().direct_space_state.intersect_ray(target.global_transform.origin, _caster.global_body_center())
	return result && result["collider"] == _caster

func spawn_object(spawn_time:float=0.0, id:int=_objects.size()):
	if(_objects.size() >= amount):
		return
	var new_object: Area = example_object.duplicate()
	errors.error_test(new_object.connect("body_entered", self, "_object_enter", [new_object]))
	errors.error_test(new_object.connect("body_exited", self, "_object_exit", [new_object]))
	new_object.translation = first_object_position(new_object, _objects.size())
	_objects.insert(id, [spawn_time, new_object])
	add_child(new_object)
	set_object_active(new_object, can_reach_caster(new_object))
	if(_objects.size() < amount):
		spawn_timer.start()

func _object_enter(body: Node, _collider: Area):
	if(body):
		if(body == _caster):
			_caster_affected = true
			body.damage(spells.get_pain(spell, "self"))
		elif(body.has_method("damage")):
			_affected_bodies.push_back(body)
			body.damage(spells.get_pain(spell, "target"))

func _object_exit(body: Node, _collider: Area):
	if(body == _caster):
		_caster_affected = false
	_affected_bodies.erase(body)
