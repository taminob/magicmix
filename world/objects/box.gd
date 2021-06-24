extends RigidBody

# warning-ignore:unused_class_variable
var interaction_name: String = "Open"
func interact(interactor: character):
	var item_list = game.world.boxes[game.levels.current_level_name][name]
	if(item_list.empty()):
		return
	#var item_anim = interactor.get_node_or_null("item_popup")
	#if(item_anim):
	#	create_pickup_anim(item_anim, item_list)
	#interactor.interaction.add_items(item_list)
	interactor.inventory.things.append_array(item_list)
	item_list.clear()

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
