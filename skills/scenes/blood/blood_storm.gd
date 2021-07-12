extends Area

var spell: abstract_spell
var _affected_bodies: Array = []
onready var _caster: Node = $".."
var _caster_affected: bool = false
onready var _collision: CollisionShape = $"collision" # todo: expand collision radius (no pre-processed particles)

func _ready():
	spell = skill_data.spells["blood_storm"]
	_collision.shape.radius = spell.range()
	errors.error_test(connect("body_entered", self, "_object_enter"))
	errors.error_test(connect("body_exited", self, "_object_exit"))

func _physics_process(delta: float):
	for x in _affected_bodies:
		x.damage(spell.target_pain_per_second() * delta)
		x.damage(spell.target_focus_per_second() * delta, true)
		# todo: target_focus
	if(_caster_affected):
		_caster.damage(spell.self_focus_per_second() * delta)

func _object_enter(body: Node):
	if(body):
		if(body == _caster):
			_caster_affected = true
			body.damage(spell.self_pain())
		elif(body.has_method("damage")):
			_affected_bodies.push_back(body)
			body.damage(spell.target_pain())
			body.damage(spell.target_focus(), true)

func _object_exit(body: Node):
	if(body == _caster):
		_caster_affected = false
	_affected_bodies.erase(body)
