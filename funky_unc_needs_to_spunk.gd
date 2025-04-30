extends Node3D

var Player = preload("res://Scenes/Player.tscn").instantiate()
#var cur_scene = preload("res://funky unc needs to spunk.tscn")
#var tree = get_tree()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

@onready var control = $CanvasLayer/Control

func _on_button_pressed() -> void:
	control.hide()
	
	var instance = Player.instantiate()
	add_child(instance)
	
	
