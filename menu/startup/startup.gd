extends Control

func _ready():
	loader.load_resource("res://menu/main_menu/main_menu.tscn", funcref(scenes, "create_scene"), true)
