extends spell_spawner

func _ready():
	spell = spells.get_spell("fire_storm")
	amount = 500
	radius = spells.get_range(spell)
	time = 2
	example_object = preload("fire.tscn").instance()
	example_object.set_scale(Vector3(0.4, 0.4, 0.4))
	spawn_timer.set_wait_time(0.05)
	spawn_timer.start()
