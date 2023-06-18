extends Area3D

class_name spell_expander

var time: float
var spell: abstract_spell
var object: Area3D = null
var _affected_bodies: Array = []
# warning-ignore:unused_class_variable
var caster: CharacterBody3D

func position() -> Vector3:
	return caster.global_transform.origin

func next_object_scale(_delta: float) -> Vector3:
	return object.scale

func do_on_end():
	pass

func connect_object():
	errors.error_test(object.connect("body_entered", Callable(self, "_object_enter")))
	errors.error_test(object.connect("body_exited", Callable(self, "_object_exit")))

func init_object():
	connect_object()
	if(object != self):
		add_child(object)
	object.global_transform.origin = position()

func _physics_process(delta: float):
	if(!object || !spell):
		return
	time -= delta
	if(time <= 0):
		do_on_end()
		spell = null
		return
	object.scale = next_object_scale(delta)

	for x in _affected_bodies:
		x.damage(spell.target_pain_per_second() * delta, spell.target_element(), caster)
		x.damage(spell.target_focus_per_second() * delta, abstract_spell.element_type.focus, caster)

func _object_enter(body: Node):
	if(body && body.has_method("damage") && body != caster):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), spell.target_element(), caster)
		body.damage(spell.target_focus(), abstract_spell.element_type.focus, caster)

func _object_exit(body: Node):
	_affected_bodies.erase(body)
