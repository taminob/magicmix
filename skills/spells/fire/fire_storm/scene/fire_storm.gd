extends spell_spawner

func _ready():
	amount = 1000
	radius = spell.range()
	time = 2
	set_example_object(preload("res://skills/spells/scene_helpers/fire.tscn").instantiate())
	#example_object.set_scale(Vector3(0.4, 0.4, 0.4))
	amount_per_spawn = 10
	spawn_timer.set_wait_time(0.1)
	spawn_timer.start()

func initial_position(target: CollisionObject3D, object_id: int):
	super.initial_position(target, object_id)

func move_to_next_position(target: CollisionObject3D, _object_id: int, object_age: float, delta: float):
	var offset = Vector3(sin(100 * object_age) * 30 * delta, -9.81 * delta, cos(100 * object_age) * 30 * delta)
	return target.position + offset
