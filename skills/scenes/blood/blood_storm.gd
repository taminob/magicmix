extends Area

var spell: abstract_spell
var _affected_bodies: Array = []
onready var caster: KinematicBody
onready var _collision: CollisionShape = $"collision" # todo: expand collision radius (no pre-processed particles)

func _ready():
	_collision.shape.radius = spell.range()
	errors.error_test(connect("body_entered", self, "_object_enter"))
	errors.error_test(connect("body_exited", self, "_object_exit"))

func _physics_process(delta: float):
	global_transform.origin = caster.global_transform.origin
	for x in _affected_bodies:
		x.damage(spell.target_pain_per_second() * delta, spell.target_element(), caster)
		x.damage(spell.target_focus_per_second() * delta, abstract_spell.element_type.focus, caster)

func _object_enter(body: Node):
	if(body && body != caster && body.has_method("damage")):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), spell.target_element(), caster)
		body.damage(spell.target_focus(), abstract_spell.element_type.focus, caster)

func _object_exit(body: Node):
	_affected_bodies.erase(body)
