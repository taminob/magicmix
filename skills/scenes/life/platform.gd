extends Spatial

var caster: KinematicBody
var spell: abstract_spell
var active_spell: skills_state.active_spell

onready var _collision: CollisionShape = $"collision_shape"

func _ready():
	var velo: Vector3 = caster.move.velocity
	velo.y = min(0, velo.y)
	global_transform.origin = caster.global_transform.origin + (velo + Vector3.DOWN) * 0.1
	var params: PhysicsShapeQueryParameters = PhysicsShapeQueryParameters.new()
	params.set_shape(_collision.shape)
	params.transform = global_transform
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var results: Array = get_world().direct_space_state.intersect_shape(params)
	if(!results.empty()):
		cancel()

func cancel():
	caster.skills.call_deferred("cancel_spell", active_spell)
