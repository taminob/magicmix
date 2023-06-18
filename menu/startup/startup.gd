extends Node

func _ready():
	loader.load_resource("res://menu/main_menu/main_menu.tscn", Callable(scenes, "create_scene"), true)
