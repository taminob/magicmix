extends Spatial

export var default_color: Color = Color(0, 0, 0)
export var size: Vector2 = Vector2(1.0, 2.6)

onready var character_mesh: MeshInstance = $"mesh"

func _ready():
	errors.debug_assert(character_mesh != null, "paths in imported character mesh do not match script!")
	set_character_color(default_color)

	if(!has_node("animations")):
		var anim: AnimationPlayer = load("characters/animations/empty_animations.tscn").instance()
		anim.name = "animations"
		add_child(anim)

func get_collision_size() -> Vector2:
	return size

func set_character_color(color: Color):
	var character_mat: Material = SpatialMaterial.new()
	character_mat.set_albedo(color)
	character_mesh.set_material_override(character_mat)

func get_collision_shape() -> Shape:
	return character_mesh.mesh.create_convex_shape()
