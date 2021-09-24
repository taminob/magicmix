extends Area

var spell: abstract_spell
var _affected_bodies: Array = []
onready var _caster: KinematicBody = $".."
onready var _collision: CollisionShape = $"collision" # todo: expand collision radius (no pre-processed particles)

func _ready():
	spell = skill_data.spells["blood_storm"]
	_collision.shape.radius = spell.range()
	errors.error_test(connect("body_entered", self, "_object_enter"))
	errors.error_test(connect("body_exited", self, "_object_exit"))

func _physics_process(delta: float):
	for x in _affected_bodies:
		x.damage(spell.target_pain_per_second() * delta, spell.target_element())
		x.damage(spell.target_focus_per_second() * delta, abstract_spell.element_type.focus)

func _object_enter(body: Node):
	if(body && body != _caster && body.has_method("damage")):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), spell.target_element())
		body.damage(spell.target_focus(), abstract_spell.element_type.focus)

func _object_exit(body: Node):
	_affected_bodies.erase(body)
