extends Node

onready var character = $".."
onready var _state = characters.get_character(character.name)
onready var move = $"move"
onready var experience = $"experience"
onready var inventory = $"inventory"
onready var stats = $"stats"
onready var skills = $"skills"
onready var dialogue = $"dialogue"

var is_player = false

func save():
	move.save(_state)
	experience.save(_state)
	inventory.save(_state)
	stats.save(_state)
	skills.save(_state)
	dialogue.save(_state)

func init():
	move.init(_state)
	experience.init(_state)
	inventory.init(_state)
	stats.init(_state)
	skills.init(_state)
	dialogue.init(_state)
