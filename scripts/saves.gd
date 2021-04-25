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

func load_save(save):
	var error = save_file.load_encrypted(SAVE_PATH + current_save, key)
	if(error != OK):
		errors.error("unable to read save file %s: %s" % [save, error])
	inventory.items = save_file.get_value("inventory", "items")
	inventory.spells = save_file.get_value("inventory", "spells")
	inventory.slots = save_file.get_value("inventory", "slots")
	inventory.player_character = save_file.get_value("characters", "player")

func save():
	save_file.set_value("inventory", "items", inventory.items)
	save_file.set_value("inventory", "spells", inventory.spells)
	save_file.set_value("inventory", "slots", inventory.slots)
	save_file.set_value("characters", "player", inventory.player_character)
	Directory.new().make_dir_recursive(SAVE_PATH)
	var error = save_file.save_encrypted(SAVE_PATH + current_save, key)
	if(error != OK):
		errors.error("unable to write save file %s: %s" % [current_save, error])
