extends spell_spawner

var speed: float = 2

func _ready():
	spell = spells.get_spell("fire_ring")
	set_example_object(preload("fire.tscn").instance())
	time = spells.get_duration(spell)
	amount = 12
	radius = spells.get_range(spell)
	spawn_timer.set_wait_time(TAU / (speed * amount))
	spawn_timer.start()

func first_object_position(_target: Area, _object_id: int) -> Vector3:
	return Vector3(sin(0 * speed), 0.1, cos(0 * speed)) * radius

func next_object_position(_target: Area, _object_id: int, object_age: float) -> Vector3:
	return Vector3(sin(object_age * speed), 0.1, cos(object_age * speed)) * radius

# todo: decide if destroy on contact with StaticBody
#func _object_enter(body: Node, collider: Area):
#	._object_enter(body, collider)
#	if(body && body is StaticBody):
#		for x in _objects:
#			if(x[1] == collider):
#				_objects.erase(x)
#				break
#		collider.queue_free()
