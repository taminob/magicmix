extends spell_spawner

func _ready():
	spell = spells.get_spell("fire_storm")
	amount = 1000
	radius = spells.get_range(spell)
	time = 2
	set_example_object(preload("fire.tscn").instance())
	#example_object.set_scale(Vector3(0.4, 0.4, 0.4))
	amount_per_spawn = 10
	spawn_timer.set_wait_time(0.1)
	spawn_timer.start()

func first_object_position(target: Area, object_id: int) -> Vector3:
	var pos = .first_object_position(target, object_id)
	pos.y = 3
	return pos

func next_object_position(target: Area, _object_id: int, object_age: float, delta: float) -> Vector3:
	var offset = Vector3(sin(100 * object_age) * 30 * delta, -9.81 * delta, cos(100 * object_age) * 30 * delta)
	return target.translation + offset
