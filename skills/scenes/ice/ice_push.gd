extends spell_expander

var GROWTH_PER_SECOND: float = 10.0
var FORCE: float = 50.0
var _pushed_bodies: Array = [] # ensure every body is only pushed once

func _ready():
	object = self
	object.set_scale(Vector3(1, 1, 1))
	init_object()
	time = spell.duration() # TODO: calculate correct time/range

func next_object_scale(delta: float) -> Vector3:
	return object.scale * (1 + GROWTH_PER_SECOND * delta)

func _push_body(body: KinematicBody):
	if(!body || _pushed_bodies.has(body)):
		return
	var direction: Vector3 = body.global_transform.origin - caster.global_transform.origin
	var push: Vector3 = direction * FORCE
	if(game.is_character(body.name)):
		body.move.velocity += push
	else:
		# TODO: allow non-character bodies to be pushed
		#body.move_and_slide(push)
		pass
	_pushed_bodies.push_back(body)

func _object_enter(body: Node):
	if(body && body.has_method("damage")):
		_affected_bodies.push_back(body)
		body.damage(spell.target_pain(), spell.target_element(), caster)
		body.damage(spell.target_focus(), abstract_spell.element_type.focus, caster)
		_push_body(body)

func _object_exit(body: Node):
	_affected_bodies.erase(body)
