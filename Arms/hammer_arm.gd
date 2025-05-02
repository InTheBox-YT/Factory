extends Node3D

@onready var hammer = $Robotarm2

var is_slamming = false
var slam_time := 0.08  # Faster slam
var return_time := 0.2  # Slower reset
var timer := 0.0
var direction := 1  

var original_rotation := Vector3(deg_to_rad(0), deg_to_rad(90), deg_to_rad(-180))
var target_rotation := Vector3(deg_to_rad(0), deg_to_rad(130), deg_to_rad(-272))

var is_paused_for_impact := false
var impact_pause_duration := 0.05  # Short freeze frame
var impact_pause_timer := 0.0

func _ready():
	hammer.rotation = original_rotation

func _process(delta):
	if is_paused_for_impact:
		impact_pause_timer += delta
		if impact_pause_timer >= impact_pause_duration:
			is_paused_for_impact = false
	else:
		if is_slamming:
			timer += delta
			var time_max = slam_time if direction == 1 else return_time
			var t = clamp(timer / time_max, 0.0, 1.0)
			var eased_t = sin(t * PI * 0.5)
			if direction == -1:
				eased_t = 1.0 - cos(t * PI * 0.5)

			if direction == 1:
				hammer.rotation = original_rotation.lerp(target_rotation, eased_t)
			else:
				hammer.rotation = target_rotation.lerp(original_rotation, eased_t)

			if t >= 1.0:
				if direction == 1:
					is_paused_for_impact = true
					impact_pause_timer = 0.0
					direction = -1
					timer = 0.0
				else:
					is_slamming = false

func _input(event):
	if event.is_action_pressed("smash") and not is_slamming:
		is_slamming = true
		direction = 1
		timer = 0.0
