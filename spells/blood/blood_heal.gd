extends spell_expander

var growth_per_second = 2

func _ready():
	spell = spells.get_spell("blood_heal")
	object = self
	object.set_scale(Vector3(1, 1, 1))
	connect_object()
	time = spells.get_duration(spell)

func next_object_scale(delta: float):
	return object.scale * (1 + growth_per_second * delta)

func _object_enter(body: Node):
	if(body):
		if(body != _caster && body.has_method("damage")):
			body.damage(spells.get_pain(spell, "target"))

func _object_exit(_body: Node):
	pass
