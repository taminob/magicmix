extends Spatial

const ROTATION_SPEED: float = 2.0
const Y_OFFSET_SPEED: float = 10.0
const Y_OFFSET_HEIGHT: float = 0.05
var time: float = 0
func _process(delta: float):
	rotate_y(ROTATION_SPEED * delta)
	time += delta
	translate(Vector3(0, sin(time * Y_OFFSET_SPEED) * Y_OFFSET_HEIGHT, 0))
