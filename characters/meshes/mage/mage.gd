extends abstract_mesh

func _ready():
	size = Vector2(1.0, 2.6)
	primary_mesh = $"Plane"
	primary_cull_disabled = true
	secondary_mesh = $"metarig/Skeleton/mesh"
	init()
