extends Spatial

export var cape_color: Color = Color(0, 0, 0)
export var size: Vector2 = Vector2(1.0, 2.6)

onready var cape_mesh: MeshInstance = $"Plane"
onready var character_mesh: MeshInstance = $"metarig/Skeleton/mesh"

func _ready():
	errors.debug_assert(cape_mesh && character_mesh, "paths in imported character mesh do not match script!")
	set_cape_color(cape_color)

	if(!has_node("animations")):
		var anim: AnimationPlayer = load("characters/animations/empty_animations.tscn").instance()
		anim.name = "animations"
		add_child(anim)

func get_collision_size() -> Vector2:
	return size

func set_cape_color(color: Color):
	var cape_mat: Material = SpatialMaterial.new()
	cape_mat.set_albedo(color)
	cape_mat.set_cull_mode(SpatialMaterial.CULL_DISABLED)
	cape_mesh.set_material_override(cape_mat)

func get_collision_shape() -> Shape:
	return cape_mesh.mesh.create_convex_shape()
