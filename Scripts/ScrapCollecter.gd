extends Area3D

@export var required_scrap_count: int = 1
@export var scrap_cube_variants: Dictionary = {
	"metal_a": preload("res://Scrap/ScrapCube.tscn"),
	"metal_c": preload("res://Scenes/scrap_nuggets.tscn"),
	"metal_b": preload("res://Scenes/scrap_tower.tscn")
}
@export var scrap_cube_dropper: Node3D

@onready var compressor = $Compressor
@onready var left_door = $LeftDoor
@onready var right_door = $RightDoor

var scrap_objects: Array[Node3D] = []
var scrap_types: Dictionary = {}
var is_processing := false
var original_position: Vector3
var slam_position: Vector3

var left_door_closed: Vector3
var left_door_open: Vector3
var right_door_closed: Vector3
var right_door_open: Vector3

var state := "idle"
var move_speed := 5.0
var wait_timer := 0.0

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

	original_position = compressor.global_position
	slam_position = original_position - Vector3(0, 17.647, 0)

	left_door_closed = left_door.global_position
	left_door_open = left_door_closed - Vector3(1.5, 0, 0)

	right_door_closed = right_door.global_position
	right_door_open = right_door_closed + Vector3(1.5, 0, 0)

func _process(delta: float) -> void:
	match state:
		"preparing":
			wait_timer -= delta
			if wait_timer <= 0.0:
				state = "slamming"

		"slamming":
			compressor.global_position = compressor.global_position.lerp(slam_position, delta * move_speed)
			left_door.global_position = left_door.global_position.lerp(left_door_open, delta * move_speed)
			right_door.global_position = right_door.global_position.lerp(right_door_open, delta * move_speed)

			if compressor.global_position.distance_to(slam_position) < 0.01:
				compressor.global_position = slam_position
				left_door.global_position = left_door_open
				right_door.global_position = right_door_open
				_process_scraps()
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
	if not body or not is_instance_valid(body):
		return

	if not body.is_in_group("scrap"):
		return

	if scrap_objects.has(body):
		return


	var scrap_type: String = body.scrap_type
	if scrap_type == "":
		push_warning("Scrap object missing 'scrap_type': " + str(body))
		return

	scrap_objects.append(body)
	scrap_types[scrap_type] = scrap_types.get(scrap_type, 0) + 1


	if not is_processing and scrap_objects.size() >= required_scrap_count:
		is_processing = true
		wait_timer = 1.0
		state = "preparing"


func _on_body_exited(body: Node3D) -> void:
	if scrap_objects.has(body):
		scrap_objects.erase(body)

		var scrap_type: String = body.scrap_type
		if scrap_types.has(scrap_type):
			scrap_types[scrap_type] -= 1
			if scrap_types[scrap_type] <= 0:
				scrap_types.erase(scrap_type)


func _process_scraps():
	print("Processing scraps...")


	var valid_types: Dictionary = {}
	for scrap in scrap_objects:
		if is_instance_valid(scrap):
			scrap.queue_free()
		var scrap_type: String = scrap.scrap_type
		if scrap_type != "":
			valid_types[scrap_type] = valid_types.get(scrap_type, 0) + 1

	scrap_objects.clear()
	scrap_types.clear()

	if valid_types.size() == 0:
		push_warning("No valid scrap types to process!")
		return


	var dominant := ""
	var max_count := 0
	for t in valid_types.keys():
		if valid_types[t] > max_count:
			max_count = valid_types[t]
			dominant = t

	print("Dominant scrap type: ", dominant)
	_spawn_scrap_cube(dominant)


func _spawn_scrap_cube(scrap_type: String):
	if scrap_cube_dropper == null:
		push_warning("scrap_cube_dropper is not assigned!")
		return

	var scene = scrap_cube_variants.get(scrap_type, null)
	if scene and scene is PackedScene:
		var cube = scene.instantiate()
		if cube is Node3D:
			get_tree().current_scene.add_child(cube)
			cube.global_position = scrap_cube_dropper.global_position
			cube.global_rotation = scrap_cube_dropper.global_rotation
			cube.scale = Vector3(0.185, 0.185, 0.185)
	else:
		push_warning("No valid scene for scrap type: %s" % scrap_type)
