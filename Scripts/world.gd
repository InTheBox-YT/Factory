extends Node3D

signal on_transition_finished

@onready var player = $Player
@onready var playerscript = ("res://Scripts/player.gd")
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var pmenu = $PauseMenu

var paused = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)
	color_rect.visible = true
	animation_player.play("Fade_out")

func _on_animation_finished(anim_name):
	if anim_name == "Fade_out":
		color_rect.visible = false
		on_transition_finished.emit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		pmenu.show()
		Engine.time_scale = 0
		#player.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		pmenu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
