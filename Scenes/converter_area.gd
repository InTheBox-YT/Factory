extends Area3D

@export var crafting_recipes: Dictionary = {
	["ScrapCube1", "ScrapCube2"]: preload("res://Scenes/WateringCan.tscn"),
	["ScrapCube1", "ScrapCube3"]: preload("res://Scenes/WateringCan.tscn"),
	["ScrapCube2", "ScrapCube3"]: preload("res://Scenes/WateringCan.tscn")
}

var scrap_cubes: Array[Node3D] = []

@onready var floor_door: Node3D = $FloorDoor

var door_closed_pos: Vector3
var door_open_pos: Vector3

var door_is_opening := false
var door_is_closing := false
var door_speed := 3.0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	door_closed_pos = floor_door.position
	door_open_pos = door_closed_pos + Vector3(1.0, 0, 0)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("scrap_cube") and not scrap_cubes.has(body):
		scrap_cubes.append(body)
		_check_crafting_conditions()

func _check_crafting_conditions() -> void:
	if scrap_cubes.size() < 2:
		return

	var types_found: Array[String] = []
	for cube in scrap_cubes:
		var scrap_type: String = cube.get("scrap_type")
		if not types_found.has(scrap_type):
			types_found.append(scrap_type)

	if types_found.size() >= 2:
		var combo: Array = [types_found[0], types_found[1]]
		combo.sort()
		for key in crafting_recipes.keys():
			var key_array: Array = key.duplicate()
			key_array.sort()
			if key_array == combo:
				_spawn_crafted_item(crafting_recipes[key])
				_clear_scrap_cubes(combo)
				_open_floor_door()
				break

func _spawn_crafted_item(scene: PackedScene) -> void:
	var new_item = scene.instantiate()
	if scrap_cubes.size() > 0:
		new_item.global_transform = scrap_cubes[0].global_transform
	get_tree().current_scene.add_child(new_item)

func _clear_scrap_cubes(types_used: Array) -> void:
	var to_remove: Array = []
	for cube in scrap_cubes:
		if cube.get("scrap_type") in types_used:
			to_remove.append(cube)
			cube.queue_free()
			if to_remove.size() == 2:
				break
	for cube in to_remove:
		scrap_cubes.erase(cube)

func _physics_process(delta: float) -> void:
	if door_is_opening:
		floor_door.position = floor_door.position.lerp(door_open_pos, door_speed * delta)
		if floor_door.position.distance_to(door_open_pos) < 0.01:
			floor_door.position = door_open_pos
			door_is_opening = false
			await get_tree().create_timer(1.0).timeout
			door_is_closing = true

	elif door_is_closing:
		floor_door.position = floor_door.position.lerp(door_closed_pos, door_speed * delta)
		if floor_door.position.distance_to(door_closed_pos) < 0.01:
			floor_door.position = door_closed_pos
			door_is_closing = false

func _open_floor_door():
	door_is_opening = true
	door_is_closing = false
