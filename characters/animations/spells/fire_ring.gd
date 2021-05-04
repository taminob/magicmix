extends "res://characters/animations/spells/spell_spawner.gd"

var speed = 2

func _ready():
	spell = spells.get_spell("fire_ring")
	example_object = load("res://characters/animations/spells/fire.tscn").instance()
	example_object.set_scale(Vector2(2, 2))
	time = spells.get_duration(spell)
	amount = 12
	radius = 200
	spawn_timer.set_wait_time(TAU / (speed * amount))
	spawn_timer.start()

func first_object_position(object, object_id):
	return Vector2(sin(0 * speed), cos(0 * speed)) * radius

func next_object_position(object, object_id, remaining_duration):
	return Vector2(sin(remaining_duration * speed), cos(remaining_duration * speed)) * radius
