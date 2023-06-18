extends Control

@onready var skill_tree_panel: Control = $".."

func clear_tree():
	for x in get_children():
		remove_child(x)

func update_tree(category: String):
	clear_tree()
	if(category.is_empty()):
		return
	var skills: Array = []
	for x in skill_data.skills.keys():
		var skill: abstract_skill = skill_data.skills[x]
		if(skill.category() != category):
			continue
		skills.push_back(x)
	var nodes: Array = []
	var level: int = 0
	while !skills.is_empty() && level < 10:
		skills = create_tree(skills, nodes, level)
		level += 1

func create_node(highlighted: bool=false) -> TextureRect:
	var frame = TextureRect.new()
	frame.texture = load("res://ui/icons/empty_slot_frame-512.png")
	frame.expand = true
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.set_material(CanvasItemMaterial.new())
	if(!highlighted):
		frame.material.set_blend_mode(BLEND_MODE_SUB)
	return frame

func skill_node(skill_id: String) -> TextureRect:
	var skill: abstract_skill = skill_data.skills[skill_id]
	var frame = create_node(game.mgmt.player.inventory.skills.has(skill_id))
	var button = TextureButton.new()
	button.expand = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.texture_normal = skill.icon()
	button.anchor_right = 1
	button.anchor_bottom = 1
	button.connect("pressed", Callable(skill_tree_panel, "_on_skill_activated").bind(skill_id))
	frame.add_child(button)
	return frame

func create_connection(texture: Texture2D) -> TextureProgressBar:
	var line = TextureProgressBar.new()
	line.texture_under = texture
	line.texture_progress = texture
	line.tint_under = Color.BLACK
	line.tint_progress = Color(0.83, 0.83, 0.83)
	return line

func straight_connection() -> TextureProgressBar:
	return create_connection(load("res://ui/panels/skill_tree/straight_connection-4096.png"))

func l_diagonal_connection() -> TextureProgressBar:
	return create_connection(load("res://ui/panels/skill_tree/l_diagonal_connection-4096.png"))

func r_diagonal_connection() -> TextureProgressBar:
	return create_connection(load("res://ui/panels/skill_tree/r_diagonal_connection-4096.png"))

func connect_nodes(from_node: Control, to_node: Control, progress: float):
	var from_mid = (from_node.anchor_left + from_node.anchor_right) / 2
	var to_mid = (to_node.anchor_left + to_node.anchor_right) / 2
	var connection: TextureProgressBar
	if(abs(from_mid - to_mid) < 0.01):
		connection = straight_connection()
		connection.anchor_left = from_mid - 0.1
		connection.anchor_right = from_mid + 0.1
	elif(from_mid < to_mid):
		connection = r_diagonal_connection()
		connection.anchor_left = from_mid#from_node.anchor_left
		connection.anchor_right = to_mid#to_node.anchor_right
	else:
		connection = l_diagonal_connection()
		connection.anchor_left = to_mid#to_node.anchor_left
		connection.anchor_right = from_mid#from_node.anchor_right
	connection.anchor_top = from_node.anchor_bottom
	connection.anchor_bottom = to_node.anchor_top
	connection.nine_patch_stretch = true
	connection.set_min(0)
	connection.set_max(1)
	connection.set_value(progress)
	add_child(connection)

func create_tree(skill_ids: Array, nodes: Array, level: int) -> Array:
	var unconnected_skills: Array = []
	var to_connect_skills: Dictionary = {}
	nodes.push_back({})
	for i in range(skill_ids.size()):
		var skill: abstract_skill = skill_data.skills[skill_ids[i]]
		if(skill.category().is_empty()):
			continue
		for x in skill.requirements():
			if(nodes[max(level - 1, 0)].has(x)):
				if(to_connect_skills.has(skill_ids[i])):
					to_connect_skills[skill_ids[i]].push_back(x)
				else:
					to_connect_skills[skill_ids[i]] = [x]
			else:
				unconnected_skills.push_back(skill_ids[i])
		if(skill.requirements().is_empty()):
			to_connect_skills[skill_ids[i]] = []

	var i: int = 0
	for x in to_connect_skills.keys():
		var node = skill_node(x)
		node.anchor_top = float(level) / 5 + 0.1 * level
		node.anchor_bottom = float(level + 1) / 5 + 0.1 * level
		node.anchor_left = float(i) / to_connect_skills.size()
		node.anchor_right = float(i + 1) / to_connect_skills.size()
		add_child(node)
		for a in to_connect_skills[x]:
			connect_nodes(nodes[level - 1][a], node, 1 if game.mgmt.player.inventory.skills.has(a) else 0)
		nodes[level][x] = node
		i += 1
	return unconnected_skills
