extends Node3D

var Player = preload("res://Scenes/sub_viewport_container.tscn")
#var tree = get_tree()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_button_pressed() -> void:
	
	#var instance = Player.instantiate()
	var loading_scene = preload("res://Scenes/LoadingScreen.tscn").instantiate()
	add_child(loading_scene) #please
	loading_scene.load_level("res://Scenes/sub_viewport_container.tscn")
	
