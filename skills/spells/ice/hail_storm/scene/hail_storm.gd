extends spell_spawner

func _ready():
	amount = 50
	radius = spell.range()
	time = spell.duration()
	set_example_object(preload("res://skills/spells/scene_helpers/hail.tscn").instance())
	#example_object.set_scale(Vector3(0.4, 0.4, 0.4))
	amount_per_spawn = 10
	spawn_timer.set_wait_time(0.1)
	spawn_timer.start()

func initial_position(target: CollisionObject, object_id: int):
	.initial_position(target, object_id)
	target.global_transform.origin.y = 20

func move_to_next_position(target: CollisionObject, _object_id: int, _object_age: float, _delta: float):
	return target.translation
