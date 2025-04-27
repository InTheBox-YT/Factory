extends CharacterBody3D

signal interact_object

@onready var ray_cast_3d = $Head/Camera3D/RayCast3D
@onready var Head = $Head
@onready var Camera = $Head/Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const Sensitivity = 0.002

var pickedObject
var collider

func _process(delta: float) -> void:
	if ray_cast_3d.is_colliding():
		collider = ray_cast_3d.get_collider()
		interact_object.emit(collider)
	else: interact_object.emit(null)

func pick_up_object(object):
	object.reparent(self)
	object.global_position = $Head/Camera3D/CarryObjectMarker.global_position
	
	await get_tree().create_timer(0.1).timeout
	pickedObject = object

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"): get_tree().quit()
	
	if event.is_action_pressed("Interact") and pickedObject:
		pickedObject.reparent(get_tree().current_scene)
		pickedObject = null

func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Head.rotate_y(-event.relative.x * Sensitivity)
		Camera.rotate_x(-event.relative.y * Sensitivity)
		Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("A", "D", "W", "S")
	var direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	

@onready var camera = $Head/Camera3D
var camera_speed = 0.1

#
	#if Input.is_action_pressed("ui_left"):
	#	rotate_y(camera_speed)
	#if Input.is_action_pressed("ui_right"):
	#	rotate_y(-camera_speed)
	#if Input.is_action_pressed("ui_up"):
	#	#camera.rotate_x(camera_speed)
	#if Input.is_action_pressed("ui_down"):
	#
