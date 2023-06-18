@tool
extends EditorScript

var frames = 250

func _run():
	var anim = AnimatedTexture.new()
	var offset_begin = 65
	anim.set_frames(frames-offset_begin)
	for i in range(frames-offset_begin):
		var str_i = str(i+offset_begin)
		for y in range(4 - str_i.length()):
			str_i = str_i.insert(0, "0")
		var tex = load("res://world/sprites/fireball/frames/" + str_i + ".png")
		anim.set_frame_texture(i, tex)
	ResourceSaver.save("res://world/sprites/fireball/fireball_loop.tres", anim)
