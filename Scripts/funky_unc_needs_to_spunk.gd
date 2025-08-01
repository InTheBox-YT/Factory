extends Node3D

var TransitionScene = preload("res://Scenes/Transition Scene.tscn")
var BaseScene = preload("res://Scenes/sub_viewport_container.tscn") #Preload the base scene

@onready var ui = $Node/CanvasLayer

var transition_node : Node = null

func _ready() -> void:
	#Hide the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_pressed() -> void:
	#Hide the ui
	ui.hide()
	
	#Transition 
	if transition_node == null:
		transition_node = TransitionScene.instantiate()
		add_child(transition_node)
	transition_node.transition()
	await transition_node.on_transition_finished
	transition_node.queue_free()
	
	#Switch scenes and unload last scene on button press
	var instance = BaseScene.instantiate()
	add_child(instance)      
	get_node("Node").queue_free()
	print("Day 0 Loaded")
