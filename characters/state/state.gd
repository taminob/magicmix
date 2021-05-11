extends Node

onready var character = $".."
onready var _state = game.get_character(character.name)
onready var move = $"move"
onready var experience = $"experience"
onready var inventory = $"inventory"
onready var stats = $"stats"
onready var skills = $"skills"
onready var dialogue = $"dialogue"
# warning-ignore:unused_class_variable
onready var interaction = $"interaction"

# warning-ignore:unused_class_variable
var is_player = false

func save():
	move.save(_state)
	experience.save(_state)
	inventory.save(_state)
	skills.save(_state)
	stats.save(_state)
	dialogue.save(_state)
	#interaction.save(_state)

func init():
	move.init(_state)
	experience.init(_state)
	inventory.init(_state)
	skills.init(_state)
	stats.init(_state)
	dialogue.init(_state)
	#interaction.init(_state)
