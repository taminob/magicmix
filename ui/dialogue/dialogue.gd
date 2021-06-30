extends Popup

onready var text: RichTextLabel = $"text"
onready var name_text: Label = $"name_background/name"
onready var answer_up: RichTextLabel = $"answer_up"
onready var answer: RichTextLabel = $"answer"
onready var answer_down: RichTextLabel = $"answer_down"

var _answer_callback: FuncRef
var selected_answer: int = 0
var answer_data: Array = []

func _unhandled_key_input(event: InputEventKey):
	if(!is_visible() || answer_data.empty()):
		return
	if(event.is_action_pressed("ui_down")):
		change_selected_answer(1, true)
	elif(event.is_action_pressed("ui_up")):
		change_selected_answer(-1, true)
	elif(event.is_action_pressed("ui_accept")):
		_answer_callback.call_func(answer_data[selected_answer][1])
	elif(event.is_action_pressed("ui_page_down")):
		change_selected_answer(answer_data.size() - 1)
	elif(event.is_action_pressed("ui_page_up")):
		change_selected_answer(0)

func change_selected_answer(num: int, offset:bool=false):
	set_dialogue_progress(-1)
	num = selected_answer + num if offset else num
	if(num >= answer_data.size()):
		num = answer_data.size() - 1
	elif(num < 0):
		num = 0
	if(num - 1 >= 0):
		answer_up.text = "> " + answer_data[num-1][0]
	else:
		answer_up.text = ""
	if(!answer_data.empty()):
		answer.text = "* " + answer_data[num][0]
	else:
		answer.text = ""
	if(num + 1 < answer_data.size()):
		answer_down.text = "> " + answer_data[num+1][0]
	else:
		answer_down.text = ""
	selected_answer = num

func set_answer_visible(is_visible: bool):
	answer_up.set_visible(is_visible)
	answer.set_visible(is_visible)
	answer_down.set_visible(is_visible)

func set_dialogue_text(say_text: String, speaker: String, answers:Array=[], answer_callback:FuncRef=null):
	name_text.set_text(speaker)
	text.set_bbcode(say_text)
	answer_data = answers
	_answer_callback = answer_callback
	set_answer_visible(!answer_data.empty())
	change_selected_answer(0)

func update_dialogue(visible_chars: int, transparency:float):
	set_transparency(transparency)
	set_dialogue_progress(visible_chars)

func set_dialogue_progress(progress: int):
	var text_length = text.get_total_character_count()
	if(progress < text_length && progress >= 0):
		text.set_visible_characters(progress)
		set_answer_visible(false)
	else:
		text.set_visible_characters(-1)
		set_answer_visible(true)

func set_transparency(percentage: float):
	set_modulate(Color(1, 1, 1, percentage))
