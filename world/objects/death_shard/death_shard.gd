extends Spatial

const ROTATION_SPEED: float = 2.0
const Y_OFFSET_SPEED: float = 0.5
const Y_OFFSET_HEIGHT: float = 0.05

onready var body: CollisionObject = $"1002"

var offset_y: float = 0
var up: bool = true

var is_uncollected_death_shard: bool = true

func _physics_process(delta: float):
	rotate_y(ROTATION_SPEED * delta)
	if(up):
		offset_y += Y_OFFSET_SPEED * delta
	else:
		offset_y -= Y_OFFSET_SPEED * delta
	if(abs(offset_y) >= Y_OFFSET_HEIGHT):
			up = !up
	translate(Vector3(0, offset_y, 0))

func pick_up():
	if(is_uncollected_death_shard):
		is_uncollected_death_shard = false
		body.collision_layer = game.mgmt.layer.spirits
		body.collision_mask = game.mgmt.layer.spells
		self.scale *= 0.33
