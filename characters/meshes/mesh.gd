extends Spatial

class_name abstract_mesh

export var default_primary_color: Color = Color(0, 0, 0)
export var default_secondary_color: Color = Color(1, 1, 1)
export var size: Vector2 = Vector2(1.0, 2.6)

onready var primary_mesh: MeshInstance
var primary_cull_disabled: bool = false
onready var secondary_mesh: MeshInstance
var secondary_cull_disabled: bool = false

# has to be called at end of _ready
func init():
	errors.debug_assert(primary_mesh != null, "primary mesh has to be set!")
	set_primary_color(default_primary_color)
	set_secondary_color(default_secondary_color)

	if(!has_node("animations")):
		var anim: AnimationPlayer = load("characters/animations/empty_animations.tscn").instance()
		anim.name = "animations"
		add_child(anim)

func get_collision_size() -> Vector2:
	return size

func set_primary_color(color: Color):
	var mat: Material = SpatialMaterial.new()
	mat.set_albedo(color)
	if(primary_cull_disabled):
		mat.set_cull_mode(SpatialMaterial.CULL_DISABLED)
	primary_mesh.set_material_override(mat)

func set_secondary_color(color: Color):
	if(!secondary_mesh):
		return
	var mat: Material = SpatialMaterial.new()
	mat.set_albedo(color)
	if(secondary_cull_disabled):
		mat.set_cull_mode(SpatialMaterial.CULL_DISABLED)
	secondary_mesh.set_material_override(mat)

func get_collision_shape() -> Shape:
	return primary_mesh.mesh.create_convex_shape()

const FROZEN_COLOR: Color = Color(0.05, 0.2, 0.4)
func set_frozen(frozen: bool):
	if(frozen):
		set_primary_color(FROZEN_COLOR)
	else:
		set_primary_color(default_primary_color)
