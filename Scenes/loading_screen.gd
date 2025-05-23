extends Control

var loading : bool
var path : String
var WaitForInput : bool

func _process(delta: float) -> void:
	if loading:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print(progress[0] * 100)
		elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			set_process(false)
			print("Level Loaded")
			ChangeScene(ResourceLoader.load_threaded_get(path))
			
	pass

func ChangeScene(resource : PackedScene):
	var currentNode = resource.instantiate()
	get_tree().root.add_child(currentNode)
	
	for item in get_tree().root.get_children():
		if item != currentNode:
			get_tree().root.remove_child(item)
			item.queue_free()

func loadLevel(path : String):
	self.path = path
	show()
	if (ResourceLoader.has_cached(path)):
		ResourceLoader.load_threaded_get(path)
	else:
		ResourceLoader.load_threaded_request(path, "", true)
		loading = true
