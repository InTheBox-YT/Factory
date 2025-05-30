extends Node3D

var TransitionScene = preload("res://Scenes/Transition Scene.tscn")
var BaseScene = preload("res://Scenes/sub_viewport_container.tscn") #Preload the base scene

var transition_node : Node = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #Hide the cursor

func _on_button_pressed() -> void:
	#Bring the Transition scene
	if transition_node == null:
		transition_node = TransitionScene.instantiate()
		add_child(transition_node)
	transition_node.transition()
	await transition_node.on_transition_finished
	transition_node.queue_free()
	
	var instance = BaseScene.instantiate()
	add_child(instance)       #Switch scenes and unload last scene on button press
	get_node("Node").queue_free()
	print("Day 0 Loaded")
