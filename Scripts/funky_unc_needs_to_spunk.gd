extends Node3D

var Player = preload("res://Scenes/sub_viewport_container.tscn")
#var tree = get_tree()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

@onready var control = $Node/CanvasLayer/Control

func _on_button_pressed() -> void:
	control.hide()
	#var instance = Player.instantiate()
	#add_child(instance)
	#get_node("Node").queue_free()
	get_node("LoadingScreen").loadLevel("res://Scenes/sub_viewport_container.tscn")
	
	
	
