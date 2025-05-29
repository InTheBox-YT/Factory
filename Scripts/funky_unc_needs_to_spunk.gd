extends Node3D

var BaseScene = preload("res://Scenes/sub_viewport_container.tscn") #Preload the base scene

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #Hide the cursor

func _on_button_pressed() -> void:
	var instance = BaseScene.instantiate()
	add_child(instance)                    #Switch scenes and unload last scene on button press
	get_node("Node").queue_free()
	print("Day 0 Loaded")
