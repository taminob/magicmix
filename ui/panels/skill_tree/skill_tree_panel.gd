extends Control

onready var tree = $"layout/split/tree"
onready var details = $"layout/split/details"
onready var detail_icon = $"layout/split/details/icon"
onready var detail_label = $"layout/split/details/label"

func _on_skill_tree_panel_visibility_changed():
	if(is_visible()):
		update_tree()

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
	#button.size_flags_horizontal = SIZE_EXPAND_FILL
	#button.size_flags_vertical = SIZE_EXPAND_FILL
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

func connect_skills(from_node: Control, to_node: Control):
	var from_mid = (from_node.anchor_left + from_node.anchor_right) / 2
	var to_mid = (to_node.anchor_left + to_node.anchor_right) / 2
	var connection: TextureProgress
	if(from_mid - to_mid < 0.01):
		connection = straight_connection()
		connection.anchor_left = from_mid - 0.1
		connection.anchor_right = from_mid + 0.1
	elif(from_mid < to_mid):
		connection = r_diagonal_connection()
		connection.anchor_left = from_node.anchor_left
		connection.anchor_right = to_node.anchor_right
	else:
		connection = l_diagonal_connection()
		connection.anchor_left = to_node.anchor_left
		connection.anchor_right = from_node.anchor_right
	connection.anchor_top = from_node.anchor_bottom
	connection.anchor_bottom = to_node.anchor_top
	tree.add_child(connection)

func update_tree(category: String=""):
	for x in tree.get_children():
		tree.remove_child(x)
	var roots: Array = []
	for x in skill_data.skills.keys():
		var skill: abstract_skill = skill_data.skills[x]
		if(!category.empty() && skill.category() != category):
			continue
		if(skill.requirements().empty()):
			roots.push_back(x)
	for i in range(roots.size()):
		var node = skill_node(roots[i])
		node.anchor_top = 0
		node.anchor_bottom = 0.2
		node.anchor_left = float(i) / roots.size()
		node.anchor_right = float(i + 1) / roots.size()
		tree.add_child(node)

func _on_life_pressed():
	update_tree("life")

func _on_fire_pressed():
	update_tree("fire")

func _on_darkness_pressed():
	update_tree("darkness")

func _on_blood_pressed():
	update_tree("blood")

func _set_slot(num: int):
	get_node("layout/list/detail_popup/slots/slot" + 
	str(num)).set_normal_texture(skill_data.spells[game.mgmt.player.inventory.get_skill_slot(num)].icon())

func _on_skill_activated(index: int):
	var current = index#list.get_item_metadata(index)
	details.set_meta("current", current)
	var spell: abstract_spell = skill_data.spells[current]
	detail_icon.set_texture(spell.icon())
	detail_label.set_text(spell.name() + "\n" + spell.description())
	for i in range(5):
		_set_slot(i)

func _on_slot_pressed(num: int):
	game.mgmt.player.inventory.set_skill_slot(num, details.get_meta("current"))
	_set_slot(num)
