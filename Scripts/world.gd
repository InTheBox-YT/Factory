extends Node3D
@onready var pmenu = $PauseMenu
var paused = false
@onready var player = $Player
@onready var playerscript = ("res://Scripts/player.gd")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		pauseMenu()
	

func pauseMenu():
	if paused:
		pmenu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.show()
	else:
		pmenu.show()
		Engine.time_scale = 0
		player.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	paused = !paused
