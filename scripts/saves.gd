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
	if(name.empty()):
		var list = saves.get_save_list()
		if(!list.empty()):
			saves.current_save = str(int(list.back()) + 1)
		else:
			saves.current_save = "0"
	else:
		saves.current_save = name
	management.player_name = "hans"
	management.change_level(load("res://world/levels/intro/intro.tscn").instance())

func load_save(save=current_save):
	#var error = save_file.load_encrypted(SAVE_PATH + save, key)
	var error = save_file.load(SAVE_PATH + save)
	if(error != OK):
		errors.error("unable to read save file %s: %s" % [save, error])
		return
	current_save = save
	inventory.items = save_file.get_value("inventory", "items")
	inventory.spells = save_file.get_value("inventory", "spells")
	inventory.slots = save_file.get_value("inventory", "slots")
	management.player_name = save_file.get_value("characters", "player")
	management.change_level(load(save_file.get_value("level", "current_level")).instance())

func save():
	save_file.set_value("inventory", "items", inventory.items)
	save_file.set_value("inventory", "spells", inventory.spells)
	save_file.set_value("inventory", "slots", inventory.slots)
	save_file.set_value("characters", "player", management.player_name)
	save_file.set_value("level", "current_level", management.current_level.filename)
	Directory.new().make_dir_recursive(SAVE_PATH)
	#var error = save_file.save_encrypted(SAVE_PATH + current_save, key)
	var error = save_file.save(SAVE_PATH + current_save)
	if(error != OK):
		errors.error("unable to write save file %s: %s" % [current_save, error])
