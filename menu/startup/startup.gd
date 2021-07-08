extends Control

func _ready():
	game.load_resource("res://menu/main_menu/main_menu.tscn", funcref(self, "_load_main_menu"))

func _load_main_menu(scene: Resource):
	scenes.open_scene(scene.instance(), true)
