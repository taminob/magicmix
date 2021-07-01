extends Spatial

onready var lid: Spatial = $"lid"

var is_open: bool = false
var _closed_transform: Transform
var _opened_transform: Transform

func _ready():
	_closed_transform = lid.transform
	_opened_transform = lid.transform
	_opened_transform.rotated(Vector3(0, 0, 1), 30).translated(Vector3(0, 0.4, 0.3))

# warning-ignore:unused_class_variable
var interaction_name: String = "Open"
func interact(interactor: character):
	if(is_open):
		close_box()
	else:
		open_box(interactor)

func open_box(interactor: character):
	transform = _opened_transform
	interaction_name = "Close"
	var item_list = game.world.boxes[game.levels.current_level_name][name]
	if(item_list.empty()):
		return
	#var item_anim = interactor.get_node_or_null("item_popup")
	#if(item_anim):
	#	create_pickup_anim(item_anim, item_list)
	#interactor.interaction.add_items(item_list)
	interactor.inventory.things.append_array(item_list)
	item_list.clear()

func close_box():
	transform = _closed_transform
	interaction_name = "Open"

#func create_pickup_anim(item_anim, item_list):
#	var old_texture = item_anim.get_texture()
#	var old_size = old_texture.get_frames()
#	var current_frame = old_texture.get_current_frame()
#	var new_texture = AnimatedTexture.new()
#	new_texture.set_oneshot(true)
#	new_texture.set_frames(old_size + item_list.size() - current_frame + 1)
#	for i in range(old_size - current_frame):
#		new_texture.set_frame_texture(i, old_texture.get_frame_texture(current_frame + i))
#	for i in range(item_list.size()):
#		new_texture.set_frame_texture(old_size - current_frame + i, items.items[item_list[i]]["icon"])
#	new_texture.set_frame_texture(new_texture.get_frames() - 1, items.items[""]["icon"])
#	new_texture.set_pause(false)
#	item_anim.set_texture(new_texture)
