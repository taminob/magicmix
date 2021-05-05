extends Popup

onready var text = $"container/text"
onready var name_text = $"name_background/name"
onready var answers_container = $"container/answers"

func set_dialogue_text(string, speaker, answers=[]):
	name_text.set_text(speaker)
	text.set_bbcode(string)
	# todo: more efficient solution required
	for x in answers_container.get_children():
		answers_container.remove_child(x)
	for x in answers:
		var label = RichTextLabel.new()
		label.set_bbcode("> " + x)
		answers_container.add_child(label)

func update_dialogue(visible_chars, transparency):
	set_transparency(transparency)
	text.set_visible_characters(visible_chars)

func set_transparency(percentage):
	set_modulate(Color(1, 1, 1, percentage))
