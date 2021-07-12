extends spell_spawner

var speed: float = 2

func _ready():
	spell = skill_data.spells["fire_ring"]
	set_example_object(preload("fire.tscn").instance())
	time = spell.duration()
	amount = 12
	radius = spell.range()
	spawn_timer.set_wait_time(TAU / (speed * amount))
	spawn_timer.start()

func first_object_position(_target: Area, _object_id: int) -> Vector3:
	return Vector3(sin(0 * speed), 0.1, cos(0 * speed)) * radius

func next_object_position(_target: Area, _object_id: int, object_age: float, _delta: float) -> Vector3:
	return Vector3(sin(object_age * speed), 0.1, cos(object_age * speed)) * radius
