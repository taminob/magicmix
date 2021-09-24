extends Spatial

class_name spell_spawner

var time: float
var amount: int
var amount_per_spawn: int = 1
var spawn_timer: Timer
var radius: float
var spell: abstract_spell
var can_spawn_behind_walls: bool = false
var destroy_on_contact: bool = false
var _spawn_amount_counter: int = 0
var _example_object: Area = null
var _objects: Array = []
var _affected_bodies: Array = []
onready var _caster: KinematicBody = $".."
var _default_collision_mask: int = game.mgmt.layer.static_world | game.mgmt.layer.objects | game.mgmt.layer.characters  | game.mgmt.layer.enemies | game.mgmt.layer.spells

# override for custom placement; return local translation
func first_object_position(_object: Area, _object_id: int) -> Vector3:
	return Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1).normalized() * radius

func next_object_position(object: Area, _object_id: int, _object_age: float, _delta: float) -> Vector3:
	return object.translation

func set_example_object(object: Area):
	_example_object = object
	_example_object.collision_mask = _default_collision_mask

func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.set_one_shot(true)
	errors.error_test(spawn_timer.connect("timeout", self, "spawn_object"))

func _physics_process(delta: float):
	if(!spell || !_example_object):
		return
	var i = 0
	while i < _objects.size():
		_objects[i][0] += delta
		if(_objects[i][0] >= time):
			_objects[i][1].queue_free()
			_objects.remove(i)
		else:
			_objects[i][1].translation = next_object_position(_objects[i][1], i, _objects[i][0], delta)
			set_object_active(_objects[i][1], can_reach_caster(_objects[i][1]))
			i += 1

	for x in _affected_bodies:
		x.damage(spell.target_pain_per_second() * delta, spell.target_element())
		x.damage(spell.target_focus_per_second() * delta, abstract_spell.element_type.focus)

func set_object_active(target: Area, active: bool=true):
	target.set_visible(active)
	target.collision_mask = _default_collision_mask if active else 0

func can_reach_caster(target: Area) -> bool:
	if(can_spawn_behind_walls):
		return true
	var result = get_world().direct_space_state.intersect_ray(target.global_transform.origin, _caster.global_body_center())
	return result && result["collider"] == _caster

func spawn_object(spawn_time: float=0.0, id: int=_objects.size()):
	if(_objects.size() >= amount):
		return
	var new_object: Area = _example_object.duplicate()
	errors.error_test(new_object.connect("body_entered", self, "_object_enter", [new_object]))
	errors.error_test(new_object.connect("body_exited", self, "_object_exit", [new_object]))
	new_object.translation = first_object_position(new_object, _objects.size())
	_objects.insert(id, [spawn_time, new_object])
	add_child(new_object)
	set_object_active(new_object, can_reach_caster(new_object))
	_spawn_amount_counter += 1
	if(_spawn_amount_counter < amount_per_spawn):
		spawn_object(spawn_time)
	elif(_objects.size() < amount):
		_spawn_amount_counter = 0
		spawn_timer.start()

func _object_enter(body: Node, collider: Area):
	if(body):
		if(body.has_method("damage")):
			_affected_bodies.push_back(body)
			body.damage(spell.target_pain(), spell.target_element())
			body.damage(spell.target_focus(), abstract_spell.element_type.focus)
		if(destroy_on_contact):
			collider.queue_free()
			for i in range(_objects.size()):
				if(_objects[i][1] == collider):
					_objects.remove(i)
					break

func _object_exit(body: Node, _collider: Area):
	_affected_bodies.erase(body)
