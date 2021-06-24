extends Node

class_name state

onready var character: character = $".."
onready var _state: Dictionary = game.get_character(character.name)
onready var move: move_state = $"move"
onready var experience: experience_state = $"experience"
onready var inventory: inventory_state = $"inventory"
onready var stats: stats_state = $"stats"
onready var skills: skills_state = $"skills"
onready var dialogue: dialogue_state = $"dialogue"
# warning-ignore:unused_class_variable
onready var interaction: interaction_state = $"interaction"

# warning-ignore:unused_class_variable
var is_player:bool = false

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
