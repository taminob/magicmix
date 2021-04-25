extends VBoxContainer


onready var button = $"item"
onready var label = $"label"
onready var list = $"label/list"
var category = ""
var selected = ""

var lists = {
	"target": [["self", "res://ui/icons/self-512.png"],
		["enemy", "res://ui/icons/enemy-512.png"],
		["area", "res://ui/icons/area_dmg_no_self-512.png"]],
	"type": [["defense", "res://ui/icons/defense-512.png"],
		["attack", "res://ui/icons/attack-512.png"]],
	"element": [["fire", "res://ui/icons/flame-512.png"],
		["life", "res://ui/icons/circle-512.png"],
		["darkness", "res://ui/icons/darkness-512.png"]],
	"item": [["dagger", "res://ui/icons/empty-512.png"],
		["shield", "res://ui/icons/empty-512.png"],
		["arrow", "res://ui/icons/empty-512.png"],
		["sword", "res://ui/icons/empty-512.png"]]
}

func _ready():
	category = name.substr(0, name.find("_"))
	fill_list(category)
	if(category == "element"):
		fill_list("item")

func fill_list(name):
	if(name != "item"):
		list.add_item("", load("res://ui/icons/empty_slot_frame-512.png"))
	for x in lists[name]:
		list.add_item(x[0], load(x[1]))

func toggle_list():
	if(list.is_visible()):
		list.hide()
	else:
		# todo: will cause problem when changing resolution with open list
		list.set_fixed_icon_size(Vector2(256, 256) * display_settings.global_scale)
		list.show()

func _on_item_pressed():
	toggle_list()

func _on_list_item_activated(index):
	button.texture_normal = list.get_item_icon(index)
	selected = list.get_item_text(index)
	label.set_text(label.get_text().substr(0, label.get_text().find("\n")) +
		"\n" + list.get_item_text(index))
	# todo: save spell component
	list.hide()
