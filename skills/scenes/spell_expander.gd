extends Area

class_name spell_expander

var time: float
var spell: abstract_spell
var object: Area = null
var _affected_bodies: Array = []
# warning-ignore:unused_class_variable
onready var _caster: KinematicBody = $".."

func next_object_scale(_delta: float) -> Vector3:
	return object.scale

func do_on_end():
	pass

func connect_object():
	errors.error_test(object.connect("body_entered", self, "_object_enter"))
	errors.error_test(object.connect("body_exited", self, "_object_exit"))

func init_object():
	connect_object()
	add_child(object)

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
		x.damage(spell.target_pain_per_second() * delta, stats_state.element_type.raw) # todo
		x.damage(spell.target_focus_per_second() * delta, stats_state.element_type.focus)

func _object_enter(body: Node):
	if(body && body.has_method("damage")):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), stats_state.element_type.raw) # todo
		body.damage(spell.target_focus(), stats_state.element_type.focus)

func _object_exit(body: Node):
	_affected_bodies.erase(body)
