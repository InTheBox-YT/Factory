extends CharacterBody3D

signal interact_object

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction: RayCast3D = $Head/Camera3D/interaction
@onready var hand: Node3D = $Head/Camera3D/Node3D/MagnetArm2/hand
@onready var joint = $Head/Camera3D/Generic6DOFJoint3D
@onready var staticbody = $Head/Camera3D/StaticBody3D
@onready var hammer_arm: Node3D = $Head/Camera3D/Node3D/HammerArm
@onready var magnet_arm: Node3D = $Head/Camera3D/Node3D/MagnetArm2

const SPEED := 3.2
const JUMP_VELOCITY := 0
const SENSITIVITY := 0.002
const HEADBOB_SPEED := 0.0
const HEADBOB_AMOUNT := 0.05
const SWAY_AMOUNT := 0.0025
const SWAY_SPEED := 8.0
const TILT_AMOUNT := 5.0
const TILT_SPEED := 6.0
const RETURN_SPEED := 2.0

var picked_object: Node3D = null
var pull_power = 10
var rotation_power = 0.04
var locked = false

var headbob_timer = 0.0
var sway_offset := Vector3.ZERO
var target_sway_offset := Vector3.ZERO
var tilt_target = 0.0
var tilt_current = 0.0
var moving_camera = false

var hammer_arm_rot: Basis
var magnet_arm_rot: Basis

func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hammer_arm_rot = hammer_arm.global_transform.basis
	magnet_arm_rot = magnet_arm.global_transform.basis

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_mouse_look(event)

func handle_mouse_look(event: InputEventMouseMotion) -> void:
	head.rotate_y(-event.relative.x * SENSITIVITY)
	camera.rotate_x(-event.relative.y * SENSITIVITY)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-50), deg_to_rad(60))
	target_sway_offset.x = -event.relative.x * SWAY_AMOUNT
	target_sway_offset.y = -event.relative.y * SWAY_AMOUNT
	tilt_target = clamp(event.relative.x * -TILT_AMOUNT, -TILT_AMOUNT, TILT_AMOUNT)
	moving_camera = true

func _process(delta: float) -> void:
	update_interact_ray()
	update_camera_sway(delta)
	update_arms_follow(delta)

func update_interact_ray() -> void:
	pass

func update_camera_sway(delta: float) -> void:
	if not moving_camera:
		target_sway_offset = Vector3.ZERO
		tilt_target = 0.0

	sway_offset = sway_offset.lerp(target_sway_offset, delta * SWAY_SPEED)
	tilt_current = lerp(tilt_current, tilt_target, delta * TILT_SPEED)

	var input_dir = Input.get_vector("A", "D", "W", "S")
	if input_dir.length() > 0 and is_on_floor():
		headbob_timer += delta * HEADBOB_SPEED
	else:
		headbob_timer = 0.0

	var bob_offset = Vector3(0, sin(headbob_timer) * HEADBOB_AMOUNT, 0)

	head.position = sway_offset + bob_offset
	head.rotation.z = deg_to_rad(tilt_current)

	moving_camera = false

func update_arms_follow(delta: float) -> void:
	var target_rot = camera.global_transform.basis
	var smooth_factor = 10.0
	hammer_arm_rot = hammer_arm_rot.slerp(target_rot, delta * smooth_factor)
	magnet_arm_rot = magnet_arm_rot.slerp(target_rot, delta * smooth_factor)
	hammer_arm.global_transform.basis = hammer_arm_rot
	magnet_arm.global_transform.basis = magnet_arm_rot

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)

	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		var direction = (b - a)
		picked_object.linear_velocity = direction * pull_power

		if picked_object is RigidBody3D:
			picked_object.angular_velocity *= 0.1  

		var target_rot = camera.global_transform.basis
		var obj_transform = picked_object.global_transform
		obj_transform.basis = obj_transform.basis.slerp(target_rot, delta * 2.0)
		picked_object.global_transform = obj_transform

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_movement(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("A", "D", "W", "S")

	var head_yaw = head.rotation.y
	var move_basis = Basis(Vector3.UP, head_yaw)
	var direction = (move_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func remove_object():
	if picked_object != null:
		picked_object = null

func drop_object() -> void:
	if picked_object:
		picked_object.reparent(get_tree().current_scene)
		picked_object = null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lclick"):
		if picked_object == null:
			pick_object()
		else:
			remove_object()

func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider
