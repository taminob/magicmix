extends "res://characters/animations/spells/spell_spawner.gd"

func _ready():
	time = 2
	amount = 500
	spawn_timer.set_wait_time(0.05)
	radius = 500
	spell = spells.get_spell("fire_storm")
	example_object = load("res://characters/animations/spells/fire.tscn").instance()
	example_object.set_scale(Vector2(3, 3))
	spawn_timer.start()
