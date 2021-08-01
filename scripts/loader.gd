extends Node

var _loading_scene: PackedScene = load("res://menu/loading/loading.tscn")
var _loading_instance: Control
var _load_thread
var _finished_resources: Dictionary = {}
var _load_queue: Array = []
var _queue_mutex: Mutex = Mutex.new()
var _finished_mutex: Mutex = Mutex.new()

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _load_resource(path: String, callback: FuncRef=null):
	if(_finished_resources.has(path)):
		return
	if(ResourceLoader.has_cached(path)):
		_finished_resources[path] = ResourceLoader.load(path)
		return
	var new_loader: ResourceInteractiveLoader = ResourceLoader.load_interactive(path)
	new_loader.set_meta("path", path)
	new_loader.set_meta("callback", callback)
	_queue_mutex.lock()
	_load_queue.push_back(new_loader)
	_queue_mutex.unlock()

func load_resource(path: String, callback: FuncRef, loading_screen: bool):
	if(loading_screen):
		open_loading_screen()
	_load_resource(path, callback)
	if(!_load_thread):
		_load_thread = Thread.new()
		_load_thread.start(self, "_thread_process")
	set_process(true)

func open_loading_screen():
	if(_loading_instance):
		return
	_loading_instance = _loading_scene.instance()
	scenes.open_scene(_loading_instance)
	get_tree().paused = true

func close_loading_screen():
	if(_loading_instance):
		if(scenes.current_scene == _loading_instance):
			scenes.close_scene()
		else:
			scenes.previous_scenes.erase(_loading_instance)
		_loading_instance = null
		get_tree().paused = false

func _process(_delta: float):
	if(_load_queue.empty() && _load_thread):
		_load_thread.wait_to_finish()
		_load_thread = null
		close_loading_screen()
		set_process(false)
		for x in _finished_resources.values():
			x[1].call_func(x[0])
		_finished_resources.clear()
	elif(_loading_instance):
		var total_stages: int = 0
		var current_progress: float = 0.0
		_queue_mutex.lock()
		for x in _load_queue:
			total_stages += x.get_stage_count()
			current_progress += x.get_stage()
		_queue_mutex.unlock()
		if(total_stages > 0):
			_loading_instance.set_progress(current_progress / total_stages)
		else:
			_loading_instance.set_progress(1)

func _thread_process(_a):
	while !_load_queue.empty():
		_queue_mutex.lock()
		var current: ResourceInteractiveLoader = _load_queue.front()
		_queue_mutex.unlock()
		match current.poll():
			OK:
				pass
			ERR_FILE_EOF:
				_finished_mutex.lock()
				_finished_resources[current.get_meta("path")] = [current.get_resource(), current.get_meta("callback")]
				_finished_mutex.unlock()
				_load_queue.pop_front()
			_:
				errors.error("loading: unable to interactively load resource: " + current.get_meta("path"))
