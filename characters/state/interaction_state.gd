extends Node

class_name interaction_state

@onready var state: Node = get_parent()
@onready var pawn: CharacterBody3D = $"../.."
@onready var inventory: Node = $"../inventory"
@onready var stats: Node = $"../stats"
@onready var move: Node = $"../move"

var targets: Array = []

func get_target() -> Node:
	if(targets.is_empty()):
		return null
	return targets.back()

func initiate_interact():
	if(!targets.is_empty()):
		targets.back().interact(pawn)

func consume(item: String, remove_from_inventory: bool=true):
	if(item_data.items[item].category() != "consumable"):
		return
	if(remove_from_inventory):
		inventory.things.erase(item)
	# todo? elemental damage from item
	stats._self_damage(item_data.items[item].self_pain())
	stats._self_focus_damage(item_data.items[item].self_focus())
	# todo: damage over time

func toggle_spirit():
	state.is_spirit = !state.is_spirit

	if(state.is_spirit):
		pawn.spirit = load("res://characters/spirit.tscn").instantiate()
		pawn.spirit.position = pawn.position + 2 * Vector3.UP
		pawn.spirit.set_name(pawn.name + "_spirit")
		pawn.spirit.pawn = pawn
		pawn.get_parent().add_child(pawn.spirit)
		if(state.is_player):
			var spirit_camera: Node3D = load("res://characters/player/camera.tscn").instantiate()
			spirit_camera.set_name("spirit_camera")
			spirit_camera.rotation_axes = Vector2(1, 1)
			pawn.spirit.add_child(spirit_camera)
			spirit_camera.make_current()
			pawn.process_mode = PROCESS_MODE_ALWAYS
			pawn.spirit.process_mode = PROCESS_MODE_ALWAYS
			spirit_camera.process_mode = PROCESS_MODE_ALWAYS
			get_tree().paused = true
	else:
		pawn.spirit.queue_free()
		pawn.spirit = null
		move.spirit_velocity = Vector3.ZERO
		if(state.is_player):
			game.mgmt.camera.make_current()
			get_tree().paused = false
			pawn.process_mode = PROCESS_MODE_INHERIT

func get_near_bodies(radius: float, is_match: Callable, in_sight_only: bool=true) -> Array:
	pawn.detect_zone.get_node("collision").shape.radius = radius
	var bodies: Array = []
	for body in pawn.detect_zone.get_overlapping_bodies():
		if(is_match.call(body)):
			if(in_sight_only):
				# todo? still unreliably! maybe multiple raycasts?
				pawn.ray.set_target_position(pawn.to_local(body.global_transform.origin))
				pawn.ray.force_update_transform() # todo: necessary?
				pawn.ray.force_raycast_update()
				var result = pawn.ray.get_collider()
				if(result != body):
					continue
			bodies.push_back(body)
	return bodies

func _on_interact_zone_entered(body_or_area: Node):
	if(body_or_area && body_or_area.has_method("interact") && body_or_area != pawn):
		targets.push_back(body_or_area)
		if(state.is_player):
			game.mgmt.ui.show_interaction(body_or_area.get_interaction(), null)
		else:
			state.ai.should_reconsider = true

# todo: if there is another target still in zone, switch to it
func _on_interact_zone_exited(body_or_area: Node):
	if(targets.has(body_or_area)):
		targets.erase(body_or_area)
		if(state.is_player):
			if(targets.is_empty()):
				game.mgmt.ui.hide_interaction()
			else:
				game.mgmt.ui.show_interaction(targets.back().get_interaction(), null)
		else:
			state.ai.should_reconsider = true
