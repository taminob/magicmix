extends Control

onready var tree = $"layout/split/tree"
onready var details = $"layout/split/details"
onready var detail_icon = $"layout/split/details/icon"
onready var detail_label = $"layout/split/details/label"

func _on_skill_tree_panel_visibility_changed():
	if(is_visible()):
		update_tree() # todo? restore last tree?

func create_node() -> TextureRect:
	var frame = TextureRect.new()
	frame.texture = load("res://ui/icons/empty_slot_frame-512.png")
	frame.expand = true
	frame.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return frame

func skill_node(skill_id: String) -> TextureRect:
	var skill: abstract_skill = skill_data.skills[skill_id]
	var frame = create_node()
	var button = TextureButton.new()
	button.expand = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.texture_normal = skill.icon()
	button.anchor_right = 1
	button.anchor_bottom = 1
	button.connect("pressed", self, "_on_skill_activated", [skill_id])
	frame.add_child(button)
	return frame

func create_connection(texture: Texture) -> TextureProgress:
	var line = TextureProgress.new()
	line.texture_under = texture
	line.texture_progress = texture
	return line

func straight_connection() -> TextureProgress:
	return create_connection(load("res://ui/panels/skill_tree/straight_connection-4096.png"))

func l_diagonal_connection() -> TextureProgress:
	return create_connection(load("res://ui/panels/skill_tree/l_diagonal_connection-4096.png"))

func r_diagonal_connection() -> TextureProgress:
	return create_connection(load("res://ui/panels/skill_tree/r_diagonal_connection-4096.png"))

func set_level(level: int, skill_id: String):
	pass

func connect_nodes(from_node: Control, to_node: Control):
	var from_mid = (from_node.anchor_left + from_node.anchor_right) / 2
	var to_mid = (to_node.anchor_left + to_node.anchor_right) / 2
	var connection: TextureProgress
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
	tree.add_child(connection)

func create_tree(skill_ids: Array, nodes: Array, level: int) -> Array:
	var unconnected_skills: Array = []
	var to_connect_skills: Dictionary = {}
	nodes.push_back({})
	for i in range(skill_ids.size()):
		var skill: abstract_skill = skill_data.skills[skill_ids[i]]
		if(skill.category().empty()):
			continue
		for x in skill.requirements():
			if(nodes[max(level - 1, 0)].has(x)):
				if(to_connect_skills.has(skill_ids[i])):
					to_connect_skills[skill_ids[i]].push_back(x)
				else:
					to_connect_skills[skill_ids[i]] = [x]
			else:
				unconnected_skills.push_back(skill_ids[i])
		if(skill.requirements().empty()):
			to_connect_skills[skill_ids[i]] = []

	var i: int = 0
	for x in to_connect_skills.keys():
		var node = skill_node(x)
		node.anchor_top = float(level) / 5 + 0.1 * level#skill_ids.size()
		node.anchor_bottom = float(level + 1) / 5 + 0.1 * level#skill_ids.size()
		node.anchor_left = float(i) / to_connect_skills.size()
		node.anchor_right = float(i + 1) / to_connect_skills.size()
		tree.add_child(node)
		for a in to_connect_skills[x]:
			connect_nodes(nodes[level - 1][a], node)
		nodes[level][x] = node
		i += 1
	return unconnected_skills

func update_tree(category: String=""):
	for x in tree.get_children():
		tree.remove_child(x)
	var skills: Array = []
	for x in skill_data.skills.keys():
		var skill: abstract_skill = skill_data.skills[x]
		if(!category.empty() && skill.category() != category):
			continue
		skills.push_back(x)
	var nodes: Array = []
	var level: int = 0
	while !skills.empty() && level < 10:
		skills = create_tree(skills, nodes, level)
		level += 1

func _on_life_pressed():
	update_tree("life")

func _on_fire_pressed():
	update_tree("fire")

func _on_darkness_pressed():
	update_tree("darkness")

func _on_blood_pressed():
	update_tree("blood")

func _set_slot(num: int):
	get_node("layout/split/details/slots/slot" + 
		str(num)).set_normal_texture(skill_data.spells[game.mgmt.player.inventory.get_skill_slot(num)].icon())

func _on_skill_activated(skill_id: String):
	details.set_meta("current", skill_id)
	var skill: abstract_skill = skill_data.skills[skill_id]
	detail_icon.set_texture(skill.icon())
	detail_label.set_text(skill.name() + "\n" + skill.description())
	for i in range(5):
		_set_slot(i)

func _on_slot_pressed(num: int):
	#game.mgmt.player.inventory.set_skill_slot(num, details.get_meta("current"))
	_set_slot(num)
