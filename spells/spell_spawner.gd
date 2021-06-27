extends Spatial

class_name spell_spawner

var time: float
var amount: int
var spawn_timer: Timer
var radius: float
var spell: Dictionary = {}
var example_object: Area = null
var _objects: Array = []
var _affected_bodies: Array = []
onready var _caster: character = $".."
var _caster_affected: bool = false

# override for custom placement; return position
func first_object_position(_object: Area, _object_id: int) -> Vector3:
	return Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1).normalized() * radius

func next_object_position(object: Area, _object_id: int, _remaining_duration: float) -> Vector3:
	return object.translation

func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
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
			i += 1

	for x in _affected_bodies:
		x.damage(spells.get_pain(spell, "target", true) * delta)
	if(_caster_affected):
		_caster.damage(spells.get_pain(spell, "self", true) * delta)

func spawn_object():
	var new_object: Area = example_object.duplicate()
	errors.error_test(new_object.connect("body_entered", self, "_object_enter", [new_object]))
	errors.error_test(new_object.connect("body_exited", self, "_object_exit", [new_object]))
	new_object.translation = first_object_position(new_object, _objects.size())
	_objects.push_back([0, new_object])
	add_child(new_object)
	if(_objects.size() < amount):
		if(spawn_timer.wait_time <= 0):
			spawn_object()
	else:
		spawn_timer.stop()

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
