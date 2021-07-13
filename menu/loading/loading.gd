extends Control

onready var progress: TextureProgress = $"progress"
var _loader: ResourceInteractiveLoader = null
var _new_loader: bool = false

func track_loader(loader: ResourceInteractiveLoader):
	_loader = loader
	_new_loader = true

var max_time: float = 0.1
func _process(_delta: float):
	if(_loader):
		if(_new_loader):
			_new_loader = false
			return
		var begin_time = OS.get_ticks_msec()
		while OS.get_ticks_msec() < begin_time + max_time:
			progress.set_value(float(_loader.get_stage()) / _loader.get_stage_count())
			match _loader.poll():
				ERR_FILE_EOF:
					game.finished_loading(_loader)
					_loader = null
					break
				OK:
					pass
				_:
					errors.error("loading: unable to interactively load resource!")
					break
