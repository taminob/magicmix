extends Node3D

@export var character_name: String

func _ready():
	if(character_name.is_empty()):
		character_name = name.substr(0, int(max(0, name.length() - 6)))
		errors.debug_assert(game.char_data.has(character_name)) #,"target character of spawn point does not exist")

	if(!game.get_character(character_name)):
		spawn_character()

func spawn_character():
	var new_char: CharacterBody3D = game.mgmt.create_character(character_name)
	new_char.global_transform = global_transform
