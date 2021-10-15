extends spell_expander

var growth_per_second = 0.5

func _ready():
	spell = skill_data.spells["ice_wave"]
	object = self
	object.set_scale(Vector3(1, 1, 1))
	init_object()
	time = spell.duration()

func next_object_scale(delta: float) -> Vector3:
	return object.scale * (1 + growth_per_second * delta)
