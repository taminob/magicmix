extends spell_spawner

var speed: float

func _ready():
	set_example_object(preload("res://skills/spells/scene_helpers/ice.tscn").instance())
	time = spell.duration()
	amount = 1
	if(time > 0):
		speed = spell.range() / time
	destroy_on_contact = true
	can_spawn_behind_walls = true
	spawn_object()

func initial_position(target: Area, _object_id: int):
	target.global_transform.basis = caster.global_transform.basis
	target.global_transform.origin = caster.global_transform.origin + target.global_transform.basis.xform(2 * Vector3.FORWARD + 1.25 * Vector3.UP)

func move_to_next_position(target: Area, _object_id: int, object_age: float, _delta: float):
	target.global_transform.origin = target.global_transform.origin + (object_age * speed) * target.global_transform.basis.xform(Vector3.FORWARD)
