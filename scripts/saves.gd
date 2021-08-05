extends Node

var current_save = "0"
const SAVE_PATH = "res://saves/" # todo: change to user://
#var key = OS.get_unique_id().to_utf8()

func get_latest_save() -> String:
	var dir = Directory.new()
	var file = File.new()
	dir.open(SAVE_PATH)
	dir.list_dir_begin()
	var last_save = ["", 0]
	while true:
		var file_name = dir.get_next()
		if(file_name.empty()):
			break
		elif(file_name.begins_with(".")):
			continue
		var last_modified = file.get_modified_time(SAVE_PATH + file_name)
		if(last_save[1] < last_modified):
			last_save = [file_name, last_modified]
	dir.list_dir_end()
	return last_save[0]

func get_save_list() -> Array:
	var dir = Directory.new()
	dir.open(SAVE_PATH)
	dir.list_dir_begin()
	var list: Array = []
	while true:
		var file = dir.get_next()
		if(file.empty()):
			break
		elif(!file.begins_with(".")):
			list.append(file)
	dir.list_dir_end()
	return list

func new_save(name=""):
	load_save(name) # todo: good idea?
	if(name.empty()):
		var list = get_save_list()
		if(!list.empty()):
			var save = 0
			for x in list:
				if(int(x) > save):
					save = int(x)
			current_save = str(save + 1)
		else:
			current_save = "0"
	else:
		current_save = name

var _next_level: String
func load_save(save=current_save):
	var save_file = ConfigFile.new()
	#var error = save_file.load_encrypted(SAVE_PATH + save, key) # todo? encrypted save files
	var error = save_file.load(SAVE_PATH + save)
	if(error != OK):
		errors.error("unable to read save file %s: %s" % [save, error])
	current_save = save
	game.reload_game()
	game.mgmt.player_name = save_file.get_value("characters", "player", settings.get_setting("dev", "start_character"))
	game.char_data = save_file.get_value("characters", "characters", game.char_data)
	game.world.boxes = save_file.get_value("world", "boxes", game.world.boxes)
	_next_level = save_file.get_value("level", "current_level", settings.get_setting("dev", "start_level"))
	loader.load_resource(scenes.game_scene_path, funcref(self, "_game_scene_loaded"), true)

func _game_scene_loaded(scene: PackedScene):
	scenes.create_game_scene(scene)
	game.levels.change_level(_next_level)

func save():
	var save_file = ConfigFile.new()
	save_file.set_value("characters", "player", game.mgmt.player_name)
	game.mgmt.save_characters()
	save_file.set_value("characters", "characters", game.char_data)
	save_file.set_value("world", "boxes", game.world.boxes)
	save_file.set_value("level", "current_level", game.levels.current_level_name)
	errors.error_test(Directory.new().make_dir_recursive(SAVE_PATH))
	#var error = save_file.save_encrypted(SAVE_PATH + current_save, key) # todo? encrypted save files
	var error = save_file.save(SAVE_PATH + current_save)
	if(error != OK):
		errors.error("unable to write save file %s: %s" % [current_save, error])
