extends Node

class_name spell_expander

var time
var spell: String = ""
var object: Node = null
var _affected_bodies: Array = []
onready var _caster: Node = $".."
var _caster_affected: bool = false

func next_object_scale(_delta: float):
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
	if(!object || spell.empty()):
		return
	time -= delta
	if(time <= 0):
		do_on_end()
		spell = ""
		return
	object.scale = next_object_scale(delta)

	for x in _affected_bodies:
		x.damage(spells.get_pain(spell, "target", true) * delta)
	if(_caster_affected):
		_caster.damage(spells.get_pain(spell, "self", true) * delta)

func _object_enter(body):
	if(body):
		if(body == _caster):
			_caster_affected = true
			body.damage(spells.get_pain(spell, "self"))
		elif(body.has_method("damage")):
			_affected_bodies.push_back(body)
			body.damage(spells.get_pain(spell, "target"))

func _object_exit(body):
	if(body == _caster):
		_caster_affected = false
	_affected_bodies.erase(body)
