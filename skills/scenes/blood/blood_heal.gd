extends spell_expander

var growth_per_second = 2

func _ready():
	spell = skill_data.spells["blood_heal"]
	object = self
	object.set_scale(Vector3(1, 1, 1))
	connect_object()
	time = spell.duration()

func next_object_scale(delta: float) -> Vector3:
	return object.scale * (1 + growth_per_second * delta)

func _object_enter(body: Node):
	if(body):
		if(body != _caster && body.has_method("damage")):
			body.damage(spell.target_pain())
			body.damage(spell.target_focus(), true)

func _object_exit(_body: Node):
	pass
