extends spell_spawner

var speed: float = 10

func _ready():
	set_example_object(preload("fire.tscn").instance())
	time = spell.duration()
	amount = 500
	radius = 2#spell.range()
	spawn_timer.set_wait_time(TAU / (speed * amount))
	spawn_timer.start()

func initial_position(target: Area, _object_id: int):
	target.global_transform.origin = caster.global_transform.origin + Vector3(sin(0 * speed), 0.1, cos(0 * speed)) * radius

func move_to_next_position(target: Area, _object_id: int, object_age: float, _delta: float):
	target.global_transform.origin = caster.global_transform.origin + Vector3(sin(object_age * speed), 0.1, cos(object_age * speed)) * object_age * radius
