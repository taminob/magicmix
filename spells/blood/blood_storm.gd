extends Area

var spell: Dictionary = {}
var _affected_bodies: Array = []
onready var _caster: Node = $".."
var _caster_affected: bool = false
onready var _collision: CollisionShape = $"collision" # todo: expand collision radius (no pre-processed particles)

func _ready():
	spell = spells.get_spell("blood_storm")
	_collision.shape.radius = spells.get_range(spell)
	errors.error_test(connect("body_entered", self, "_object_enter"))
	errors.error_test(connect("body_exited", self, "_object_exit"))

func _physics_process(delta: float):
	for x in _affected_bodies:
		x.damage(spells.get_pain(spell, "target", true) * delta)
	if(_caster_affected):
		_caster.damage(spells.get_pain(spell, "self", true) * delta)

func _object_enter(body: Node):
	if(body):
		if(body == _caster):
			_caster_affected = true
			body.damage(spells.get_pain(spell, "self"))
		elif(body.has_method("damage")):
			_affected_bodies.push_back(body)
			body.damage(spells.get_pain(spell, "target"))

func _object_exit(body: Node):
	if(body == _caster):
		_caster_affected = false
	_affected_bodies.erase(body)
