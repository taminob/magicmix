extends CollisionObject3D

const ROTATION_SPEED: float = 2.0
const Y_OFFSET_SPEED: float = 0.5
const Y_OFFSET_HEIGHT: float = 0.05
const SHOOT_SPEED: float = 50.0

var offset_y: float = 0
var up: bool = true

var pawn: CharacterBody3D
var is_uncollected_death_shard: bool = true
var shooting: bool = false

func _physics_process(delta: float):
	rotate(global_transform.basis.y.normalized(), ROTATION_SPEED * delta)
	if(shooting):
		global_transform.origin += global_transform.basis.y.normalized() * SHOOT_SPEED * delta
	else:
		if(up):
			offset_y += Y_OFFSET_SPEED * delta
		else:
			offset_y -= Y_OFFSET_SPEED * delta
		if(abs(offset_y) >= Y_OFFSET_HEIGHT):
				up = !up
		translate(Vector3(0, offset_y, 0))

func pick_up(new_pawn: CharacterBody3D):
	if(is_uncollected_death_shard):
		pawn = new_pawn
		is_uncollected_death_shard = false
		collision_layer = game.mgmt.layer.spirits
		collision_mask = game.mgmt.layer.spells
		scale *= 0.33

func shoot():
	scale = Vector3.ONE
	rotation = Vector3.ZERO
	rotate(pawn.global_transform.basis.x, deg_to_rad(-90))
	global_transform.origin = pawn.global_body_center() - pawn.global_transform.basis.z * 0.7
	is_uncollected_death_shard = true
	collision_layer = game.mgmt.layer.objects
	collision_mask = game.mgmt.physical_layers
	shooting = true


func _on_area_body_entered(body: Node):
	if(!shooting || !body || body == self):
		return
	if(body.has_method("damage")):
		var spell: abstract_spell = skill_data.spells[shoot_death_shards_spell.id()]
		body.damage(spell.target_pain(), spell.target_element(), pawn)
	queue_free()
