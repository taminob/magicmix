extends abstract_mesh

func _ready():
	size = Vector2(0.8, 1.8)
	primary_mesh = get_node(".")
	init()
