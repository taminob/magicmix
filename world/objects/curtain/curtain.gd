extends Node3D

@onready var skeleton = $"Armature/Skeleton3D"

func _ready():
	var bones: Array = []
	for i in range(skeleton.get_bone_count()):
		var bone_name: String = skeleton.get_bone_name(i)
		if(bone_name.begins_with("cloth")):
			bones.append(bone_name)
	skeleton.physical_bones_start_simulation(bones)
