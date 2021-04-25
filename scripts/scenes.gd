extends Node

var game_scene = load("res://main.tscn").instance()
var current_scene = null
var previous_scenes = []
var root = null

func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func open_scene(scene, clear_scene_stack=false):
	if(!scene):
		return
	if(clear_scene_stack):
		close_all_scenes()
	if(current_scene):
		previous_scenes.append(current_scene)
		root.remove_child(current_scene)
	current_scene = scene
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func open_scene_from(scene_path, clear_scene_stack=false):
	var new_scene = load(scene_path).instance()
	open_scene(new_scene, clear_scene_stack)

func close_scene():
	if(!current_scene):
		return
	root.remove_child(current_scene)
	# todo: test if game_scene should stay loaded
	if(current_scene != game_scene):
		current_scene.call_deferred("free")
	current_scene = null
	open_scene(previous_scenes.pop_back())

func close_all_scenes():
	close_scene()
	while(!previous_scenes.empty()):
		close_scene()
