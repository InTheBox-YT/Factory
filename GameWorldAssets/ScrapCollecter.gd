extends Area3D

@export var required_scrap_count: int = 5
@onready var compressor = $Compressor
@onready var left_door = $LeftDoor
@onready var right_door = $RightDoor

var scrap_objects: Array[Node3D] = []

var is_processing = false
var original_position: Vector3
var slam_position: Vector3

var left_door_closed: Vector3
var left_door_open: Vector3
var right_door_closed: Vector3
var right_door_open: Vector3

var state = "idle"
var move_speed = 4.0
var wait_timer = 0.0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

	original_position = compressor.global_position
	slam_position = original_position - Vector3(0, 17.647, 0)

	left_door_closed = left_door.global_position
	left_door_open = left_door_closed - Vector3(1.5, 0, 0)  

	right_door_closed = right_door.global_position
	right_door_open = right_door_closed + Vector3(1.5, 0, 0)  

func _process(delta):
	match state:
		"slamming":
			compressor.global_position = compressor.global_position.lerp(slam_position, delta * move_speed)
			left_door.global_position = left_door.global_position.lerp(left_door_open, delta * move_speed)
			right_door.global_position = right_door.global_position.lerp(right_door_open, delta * move_speed)
			
			if compressor.global_position.distance_to(slam_position) < 0.01:
				compressor.global_position = slam_position
				left_door.global_position = left_door_open
				right_door.global_position = right_door_open
				_delete_scraps()
				wait_timer = 0.2
				state = "waiting"

		"waiting":
			wait_timer -= delta
			if wait_timer <= 0.0:
				state = "returning"

		"returning":
			compressor.global_position = compressor.global_position.lerp(original_position, delta * move_speed)
			left_door.global_position = left_door.global_position.lerp(left_door_closed, delta * move_speed)
			right_door.global_position = right_door.global_position.lerp(right_door_closed, delta * move_speed)

			if compressor.global_position.distance_to(original_position) < 0.01:
				compressor.global_position = original_position
				left_door.global_position = left_door_closed
				right_door.global_position = right_door_closed
				state = "idle"
				is_processing = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("scrap") and body not in scrap_objects:
		scrap_objects.append(body)
		check_quota()

func _on_body_exited(body: Node3D) -> void:
	if body in scrap_objects:
		scrap_objects.erase(body)

func check_quota():
	if is_processing or scrap_objects.size() < required_scrap_count:
		return

	is_processing = true
	state = "slamming"

func _delete_scraps():
	for scrap in scrap_objects:
		scrap.queue_free()
	scrap_objects.clear()
	print("Quota reached! Scraps deleted.")
