extends abstract_mesh

func _ready():
	size = Vector2(1.0, 2.6)
	primary_mesh = $"Plane"
	primary_cull_disabled = true
	secondary_mesh = $"metarig/Skeleton3D/mesh"
	init()

func set_frozen(frozen: bool):
	set_secondary_color(FROZEN_COLOR if frozen else default_secondary_color)

func set_undead(undead: bool):
	set_secondary_color(UNDEAD_COLOR if undead else default_secondary_color)
