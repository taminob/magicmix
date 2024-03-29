extends Popup

var commands = {
	"help": {
		"handler": funcref(self, "help_handler"),
		"possible": [],
		"accept_none": true
	},
	"load": {
		"handler": funcref(self, "load_handler"),
		"possible": game.levels.level_data.keys()
	},
	"exit": {
		"handler": funcref(self, "unpause")
	},
	"reload": {
		"handler": funcref(self, "load_handler")
	},
	"save": {
		"handler": funcref(saves, "save")
	},
	"quit": {
		"handler": funcref(self, "quit_handler"),
		"possible": ["force"],
		"accept_none": true
	},
	"inspect": {
		"handler": funcref(self, "inspect_handler"),
		"possible": game.char_data.keys(),
		"accept_none": true
	},
	"control": {
		"handler": funcref(self, "control_handler"),
		"possible": game.char_data.keys()
	},
	"spawn": {
		"handler": funcref(self, "spawn_handler"),
		"possible": game.char_data.keys()
	},
	"respawn": {
		"handler": funcref(self, "respawn_handler")
	},
	"kill": {
		"handler": funcref(self, "kill_handler"),
		"possible": game.char_data.keys()
	},
	"give_all": {
		"handler": funcref(self, "give_all_handler")
	},
	"heal": {
		"handler": funcref(self, "heal_handler")
	}
}

func control_handler(character_id: String):
	var is_in_death_realm: bool = game.levels.current_level_data.is_in_death_realm()
	var char_data: Dictionary = game.get_character_data(character_id)
	if(char_data.has("stats")):
		if(!char_data["stats"].get("undead", false)):
			char_data["stats"]["dead"] = is_in_death_realm
	else:
		char_data["stats"] = {"dead": is_in_death_realm}
	var new_player: KinematicBody = game.get_character(character_id)
	if(new_player):
		game.mgmt.make_player(new_player)
	else:
		game.mgmt.player_id = character_id
		game.mgmt.create_player()
		game.levels.current_level.add_child(game.mgmt.player)

func inspect_handler(character_id: String=""):
	if(!game.char_data.has(character_id)):
		character_id = ""
	settings.set_setting("dev", "debug_target", character_id)

func load_handler(level_id: String=game.levels.current_level_data.id()):
	errors.debug_assert(game.levels.level_data.has(level_id), "entered invalid level_id in console: " + level_id)
	if(game.levels.level_data[level_id].is_in_death_realm()):
		game.mgmt.player.stats.dead = true
	else:
		game.mgmt.player.revive()
	game.levels.change_level(level_id)

func spawn_handler(character_id: String):
	if(game.get_character(character_id)):
		errors.debug_output(character_id + " already exists!")
		return
	var is_in_death_realm: bool = game.levels.current_level_data.is_in_death_realm()
	var char_data: Dictionary = game.get_character_data(character_id)
	if(char_data.has("stats")):
		if(!char_data["stats"].get("undead", false)):
			char_data["stats"]["dead"] = is_in_death_realm
	else:
		char_data["stats"] = {"dead": is_in_death_realm}
	var spawn_pos: Vector3 = game.mgmt.player.global_transform.origin + 2.0 * Vector3.FORWARD
	var new_char: KinematicBody = game.mgmt.create_character(character_id)
	game.levels.current_level.add_child(new_char)
	new_char.global_transform.origin = spawn_pos

func kill_handler(character_id: String):
	var target: KinematicBody = game.get_character(character_id)
	if(target):
		target.die()
	else:
		errors.debug_output(character_id + " is not spawned!")

func respawn_handler():
	var spawn = game.levels.current_level.get_node_or_null("player_spawn")
	if(spawn):
		game.mgmt.player.global_transform = spawn.global_transform
	else:
		game.mgmt.player.global_transform = Transform.IDENTITY

func quit_handler(force: String=""):
	if(force.empty()):
		saves.save()
		get_tree().quit()
	elif(force.to_lower() != "force"):
		invalid_argument("quit")
	else:
		get_tree().quit()

func help_handler(command: String="", clear_output: bool=true):
	var new_text: String = "" if clear_output else output.get_text() + '\n'
	if(command.empty()):
		new_text += "Available commands:\n" + str(commands.keys())
	else:
		var command_entry = commands.get(command)
		if(!command_entry):
			invalid_argument("help")
		var possible_args: Array = command_entry.get("possible", [])
		new_text += "Possible arguments for '" + command + ": " + str(possible_args)
		if(command_entry.get("accept_none", false)):
			new_text += " or none"
	output.set_text(new_text)

func give_all_handler():
	for x in skill_data.spells.keys():
		game.mgmt.player.inventory.add_spell(x)
	game.mgmt.player.inventory.skill_points = skill_data.skills.keys().size()
	for x in skill_data.skills.keys():
		game.mgmt.player.inventory.add_skill(x)

func heal_handler():
	if(!game.mgmt.player.stats.dead):
		game.mgmt.player.stats.pain = 0
	game.mgmt.player.stats.focus = game.mgmt.player.stats.max_focus()
	game.mgmt.player.stats.stamina = game.mgmt.player.stats.max_stamina()

onready var output = $"output_background/output"
onready var input = $"command_input"

var hidden: bool = true

func unpause():
	input.clear()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hidden = true
	get_tree().paused = false
	hide()

func pause():
	input.clear()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hidden = false
	get_tree().paused = true
	popup()

func _enter_tree():
	if(!hidden):
		get_tree().paused = true
		call_deferred("popup")

func _input(event: InputEvent):
	if(!settings.get_setting("dev", "console")):
		return
	if(event.is_action_pressed("console") && get_tree().paused != hidden):
		if(hidden):
			pause()
		else:
			unpause()
		get_tree().set_input_as_handled() # todo: watch if this fix is a good solution to prevent the activation character to appear in input field (caused because _gui_input() is called after _input())

func invalid_command():
	output.set_text("Invalid command! Did you try 'help'?")

func invalid_argument(command: String):
	output.set_text("Invalid argument!")
	help_handler(command, false)

func _on_command_input_text_changed(_new_text: String):
	# todo: autocompletion and suggestions
	pass

func _on_command_input_text_entered(new_text: String):
	# todo: improve parsing and command handling; more robust and allow multiple arguments and complexer commands
	commands["help"]["possible"] = commands.keys()
	var input_strings: PoolStringArray = new_text.to_lower().split(' ', false)
	if(input_strings.empty()):
		return
	var command = commands.get(input_strings[0])
	if(!command):
		invalid_command()
		return
	var handler = command.get("handler")
	if(!handler):
		output.set_text("Internal error: no command handler found!")
		return
	var possible_args = command.get("possible")
	var accept_none = command.get("accept_none")
	if(input_strings.size() < 2 && (accept_none || !possible_args || possible_args.empty())):
		handler.call_func()
	elif(input_strings.size() > 1 && possible_args.has(input_strings[1])):
		handler.call_func(input_strings[1])
	else:
		invalid_argument(input_strings[0])
		return
	input.clear()
