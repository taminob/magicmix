extends Node

class_name main_state

onready var pawn: KinematicBody = $".."
onready var _state: Dictionary = game.get_character_data(pawn.name)
onready var move: move_state = $"move"
onready var experience: experience_state = $"experience"
onready var inventory: inventory_state = $"inventory"
onready var stats: stats_state = $"stats"
onready var skills: skills_state = $"skills"
onready var dialogue: dialogue_state = $"dialogue"
# warning-ignore:unused_class_variable
onready var interaction: interaction_state = $"interaction"
onready var look: look_state = $"look"
onready var ai: ai_state = $"ai"

# warning-ignore:unused_class_variable
var is_player: bool = false
# warning-ignore:unused_class_variable
var is_spirit: bool = false
# warning-ignore:unused_class_variable
var is_minion: bool = false

func save():
	move.save(_state)
	experience.save(_state)
	inventory.save(_state)
	skills.save(_state)
	stats.save(_state)
	dialogue.save(_state)
	#interaction.save(_state)
	look.save(_state)
	ai.save(_state)

func init():
	is_minion = pawn.name.find("minion") >= 0
	move.init(_state)
	experience.init(_state)
	inventory.init(_state)
	skills.init(_state)
	stats.init(_state)
	dialogue.init(_state)
	#interaction.init(_state)
	look.init(_state)
	ai.init(_state)
