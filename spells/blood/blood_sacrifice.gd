extends "../spell_expander.gd"

var growth_per_second = 3

func _ready():
	spell = spells.get_spell("blood_sacrifice")
	object = preload("ring_trigger.tscn").instance()
	object.set_scale(Vector2(0.1, 0.1))
	init_object()
	time = spells.get_duration(spell)

func next_object_scale(delta):
	return object.scale * (1 + growth_per_second * delta)

var used = false
func _object_enter(body):
	if(!used && body):
		# todo: only try to revive if dead?
		if(body != _caster && body.has_method("revive")):
			used = true
			body.revive()
			_caster.die()

func _object_exit(body):
	pass
