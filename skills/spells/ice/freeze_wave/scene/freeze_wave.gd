extends spell_expander

var growth_per_second = 1

func _ready():
	object = self
	object.set_scale(Vector3(1, 1, 1))
	init_object()
	time = spell.duration()

func next_object_scale(delta: float) -> Vector3:
	return object.scale * (1 + growth_per_second * delta)

func _object_enter(body: Node):
	if(body && body.has_method("damage") && body != caster):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), spell.target_element(), caster)
		body.damage(spell.target_focus(), abstract_spell.element_type.focus, caster)
		body.stats.temperature = -100

func _object_exit(body: Node):
	_affected_bodies.erase(body)
