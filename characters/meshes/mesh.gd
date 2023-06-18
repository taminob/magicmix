extends Node3D

class_name abstract_mesh

@export var default_primary_color: Color = Color(0, 0, 0)
@export var default_secondary_color: Color = Color(1, 1, 1)
@export var size: Vector2 = Vector2(0.6, 1.7)

@onready var primary_mesh: MeshInstance3D
var primary_cull_disabled: bool = false
@onready var secondary_mesh: MeshInstance3D
var secondary_cull_disabled: bool = false

# has to be called at end of _ready
func init():
	errors.debug_assert(primary_mesh != null, "primary mesh has to be set!")
	reset()

	if(!has_node("animations")):
		var anim: AnimationPlayer = load("characters/animations/empty_animations.tscn").instantiate()
		anim.name = "animations"
		add_child(anim)

func reset():
	set_primary_color(default_primary_color)
	set_secondary_color(default_secondary_color)

func get_size() -> Vector2:
	return size

func set_primary_color(color: Color):
	var mat: Material = StandardMaterial3D.new()
	mat.set_albedo(color)
	if(primary_cull_disabled):
		mat.set_cull_mode(StandardMaterial3D.CULL_DISABLED)
	primary_mesh.set_material_override(mat)

func set_secondary_color(color: Color):
	if(!secondary_mesh):
		return
	var mat: Material = StandardMaterial3D.new()
	mat.set_albedo(color)
	if(secondary_cull_disabled):
		mat.set_cull_mode(StandardMaterial3D.CULL_DISABLED)
	secondary_mesh.set_material_override(mat)

func get_collision_shape() -> Shape3D:
	return primary_mesh.mesh.create_convex_shape()

const FROZEN_COLOR: Color = Color(0.05, 0.2, 0.4)
func set_frozen(frozen: bool):
	set_primary_color(FROZEN_COLOR if frozen else default_primary_color)

const UNDEAD_COLOR: Color = Color(0.2, 0.2, 0.2)
func set_undead(undead: bool):
	set_primary_color(UNDEAD_COLOR if undead else default_secondary_color)
