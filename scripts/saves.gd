extends Node

var current_save = "0"
const SAVE_PATH = "res://saves/" # todo: change to user://
var save_file = ConfigFile.new()
var key = OS.get_unique_id().to_utf8()

func get_save_list():
	var dir = Directory.new()
	dir.open(SAVE_PATH)
	dir.list_dir_begin()
	var list = []
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
			var dir = Directory.new()
			var save = 0
			for x in list:
				if(int(x) > save):
					save = int(x)
			current_save = str(save + 1)
		else:
			current_save = "0"
	else:
		current_save = name

func load_save(save=current_save):
	#var error = save_file.load_encrypted(SAVE_PATH + save, key)
	var error = save_file.load(SAVE_PATH + save)
	if(error != OK):
		errors.error("unable to read save file %s: %s" % [save, error])
	current_save = save
	management.player_name = save_file.get_value("characters", "player", "hans")
	characters.characters = save_file.get_value("characters", "characters", characters.characters)
	levels.change_level(save_file.get_value("level", "current_level", "intro"))

func save():
	save_file.set_value("characters", "player", management.player_name)
	management.save_characters()
	save_file.set_value("characters", "characters", characters.characters)
	save_file.set_value("level", "current_level", levels.current_level_name)
	Directory.new().make_dir_recursive(SAVE_PATH)
	#var error = save_file.save_encrypted(SAVE_PATH + current_save, key)
	var error = save_file.save(SAVE_PATH + current_save)
	if(error != OK):
		errors.error("unable to write save file %s: %s" % [current_save, error])
