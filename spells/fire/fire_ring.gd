extends spell_spawner

var speed = 2

func _ready():
	spell = spells.get_spell("fire_ring")
	example_object = preload("fire.tscn").instance()
	example_object.set_scale(Vector3(0.5, 0.5, 0.5))
	time = spells.get_duration(spell)
	amount = 12
	radius = 5
	spawn_timer.set_wait_time(TAU / (speed * amount))
	spawn_timer.start()

func first_object_position(target: Area, _object_id: int) -> Vector3:
	return Vector3(sin(0 * speed), 1, cos(0 * speed)) * radius

func next_object_position(target: Area, _object_id: int, remaining_duration: float) -> Vector3:
	print(target.translation.y)
	return Vector3(sin(remaining_duration * speed), target.translation.y, cos(remaining_duration * speed)) * radius

func _object_enter(body: Node, collider: Area):
	if(body && body is StaticBody):
		for x in _objects:
			if(x[1] == collider):
				_objects.erase(x)
				break
		collider.queue_free()
	._object_enter(body, collider)
