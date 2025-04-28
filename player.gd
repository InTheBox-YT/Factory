extends CharacterBody3D

signal interact_object

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction: RayCast3D = $Head/Camera3D/interaction
@onready var hand: Node3D = $Head/Camera3D/hand

const SPEED := 3.5
const JUMP_VELOCITY := 2.7
const SENSITIVITY := 0.002

var picked_object: Node3D = null
var collider: Object = null

func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	update_interact_ray()

func update_interact_ray() -> void:
	if interaction.is_colliding():
		collider = interaction.get_collider()
	else:
		collider = null
	interact_object.emit(collider)
	

func pick_up_object(object: Node3D) -> void:
	object.reparent(self)
	object.global_position = hand.global_position
	await get_tree().create_timer(0.1).timeout
	picked_object = object

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
	elif event.is_action_pressed("Interact") and picked_object:
		drop_object()

func drop_object() -> void:
	picked_object.reparent(get_tree().current_scene)
	picked_object = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_mouse_look(event)

func handle_mouse_look(event: InputEventMouseMotion) -> void:
	head.rotate_y(-event.relative.x * SENSITIVITY)
	camera.rotate_x(-event.relative.y * SENSITIVITY)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_movement(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
