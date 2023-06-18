@tool
extends Node2D

@onready var particles = $"GPUParticles2D"

func _ready():
	var anim = AnimatedTexture.new()
	anim.set_frames(24)
	var atlas = load("res://world/materials/textures/fire/smoke/spr_smoke_strip24.png")
	var size = atlas.get_width()
	var x = 0
	for i in range(24):
		var tex = AtlasTexture.new()
		tex.set_atlas(atlas)
		tex.set_region_enabled(Rect2(x, 0, 32, 32))
		x += 32
		anim.set_frame_texture(i, tex)
	particles.set_texture(anim)
	ResourceSaver.save("res://world/materials/textures/fire/smoke/smoke_strip24_anim.tres", anim)
