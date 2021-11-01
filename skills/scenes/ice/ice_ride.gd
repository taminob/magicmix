extends Area

var time: float
var _affected_bodies: Array = []
var spell: abstract_spell
var caster: KinematicBody

func _ready():
	time = spell.duration()

func _physics_process(delta: float):
	global_transform = caster.global_transform
	time -= delta
	if(time <= 0):
		spell = null
		return
	for x in _affected_bodies:
		x.damage(spell.target_pain_per_second() * delta, spell.target_element(), caster)
		x.damage(spell.target_focus_per_second() * delta, abstract_spell.element_type.focus, caster)

func _object_enter(body: Node):
	if(body && body.has_method("damage")):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), spell.target_element(), caster)
		body.damage(spell.target_focus(), abstract_spell.element_type.focus, caster)

func _object_exit(body: Node):
	_affected_bodies.erase(body)

