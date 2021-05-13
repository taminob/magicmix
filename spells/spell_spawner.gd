extends Node2D

var time
var amount
var spawn_timer
var radius
var spell = null
var example_object = null
var _objects = []
var _affected_bodies = []
onready var _caster = $".."
var _caster_affected = false

# override for custom placement; return Vector2 with position
func first_object_position(_object, _object_id):
	return Vector2(randf() * 2 - 1, randf() * 2 - 1).clamped(1) * radius

func next_object_position(object, _object_id, _remaining_duration):
	return object.position

func _ready():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	errors.error_test(spawn_timer.connect("timeout", self, "spawn_object"))

func _physics_process(delta):
	if(!spell || !example_object):
		return
	var i = 0
	while i < _objects.size():
		_objects[i][0] += delta
		if(_objects[i][0] >= time):
			_objects[i][1].queue_free()
			_objects.remove(i)
		else:
			_objects[i][1].position = next_object_position(_objects[i][1], i, _objects[i][0])
			i += 1

	for x in _affected_bodies:
		x.damage(spells.get_pain(spell, "target", true) * delta)
	if(_caster_affected):
		_caster.damage(spells.get_pain(spell, "self", true) * delta)

func spawn_object():
	var new_object = example_object.duplicate()
	errors.error_test(new_object.connect("body_entered", self, "_object_enter"))
	errors.error_test(new_object.connect("body_exited", self, "_object_exit"))
	new_object.position = first_object_position(new_object, _objects.size())
	_objects.push_back([0, new_object])
	add_child(new_object)
	while spawn_timer.wait_time <= 0 && _objects.size() < amount:
		spawn_object()

func _object_enter(body):
	if(body):
		if(body == _caster):
			_caster_affected = true
			body.damage(spells.get_pain(spell, "self"))
		elif(body.has_method("damage")):
			_affected_bodies.push_back(body)
			body.damage(spells.get_pain(spell, "target"))

func _object_exit(body):
	if(body == _caster):
		_caster_affected = false
	_affected_bodies.erase(body)
