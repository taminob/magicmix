extends Node

# warning-ignore:unused_class_variable
var game_scene_path: String = "res://main.tscn"
var game_instance: Node = null
var current_scene: Node = null
var previous_scenes: Array = []
var root: Viewport = null

func _ready():
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func create_game_scene(scene: PackedScene):
	open_scene(scene.instance(), true)
	game_instance = current_scene

func create_scene(scene: PackedScene):
	open_scene(scene.instance())

func open_scene(scene: Node, clear_scene_stack: bool=false):
	if(!scene):
		return
	if(clear_scene_stack):
		close_all_scenes()
	if(current_scene):
		previous_scenes.append(current_scene)
		root.call_deferred("remove_child", current_scene)
	errors.log("open scene: " + scene.filename)
	current_scene = scene
	root.call_deferred("add_child", current_scene)
	get_tree().call_deferred("set_current_scene", current_scene)

func open_scene_from(scene_path: String, clear_scene_stack: bool=false):
	var new_scene = load(scene_path).instance()
	open_scene(new_scene, clear_scene_stack)

func close_scene():
	if(!current_scene):
		return
	root.call_deferred("remove_child", current_scene)
	# todo? test if game_scene should stay in memory
	#if(current_scene != game_instance):
	current_scene.call_deferred("free")
	current_scene = null
	open_scene(previous_scenes.pop_back())

func close_all_scenes():
	# todo? prevent open_scene in close_scene
	close_scene()
	while(!previous_scenes.empty()):
		close_scene()
