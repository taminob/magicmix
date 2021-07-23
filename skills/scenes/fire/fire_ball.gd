extends spell_spawner

var speed: float

func _ready():
	spell = skill_data.spells["fire_ball"]
	set_example_object(preload("fire.tscn").instance())
	time = spell.duration() + 1
	amount = 1
	speed = spell.range() / time
	destroy_on_contact = true
	can_spawn_behind_walls = true
	spawn_object()

func first_object_position(_target: Area, _object_id: int) -> Vector3:
	return Vector3.FORWARD + 0.5 * Vector3.UP

func next_object_position(_target: Area, _object_id: int, object_age: float, _delta: float) -> Vector3:
	return (1 + object_age * speed) * Vector3.FORWARD + 0.5 * Vector3.UP
