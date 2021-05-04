extends "res://characters/animations/spells/spell_spawner.gd"

var speed = 1

func _ready():
	spell = spells.get_spell("fire_ring")
	example_object = 
	example_object.set_scale(Vector2(2, 2))
	time = spells.get_duration(spell)
	amount = 12
	radius = 50
	spawn_timer.set_wait_time(0)
	spawn_timer.start()

func first_object_position(object, object_id):
	return Vector2(sin(object_id * speed), cos(object_id * speed)) * radius

func next_object_position(object, object_id, remaining_duration):
	return object.position
