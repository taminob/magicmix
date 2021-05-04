extends "../spell_spawner.gd"

func _ready():
	spell = spells.get_spell("blood_storm")
	amount = 1000
	radius = 700
	time = 2
	example_object = preload("blood.tscn").instance()
	example_object.set_scale(Vector2(4, 4))
	spawn_timer.set_wait_time(0.02)
	spawn_timer.start()
