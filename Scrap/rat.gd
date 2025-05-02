extends RigidBody3D

@export var move_force: float = 5.0
@export var move_interval: float = 2.0
@export var max_speed: float = 3.0

@onready var undead_mesh: Node3D = $CollisionShape3D/AliveRat
@onready var dead_mesh: Node3D = $CollisionShape3D/DeadRat
@onready var area_detector: Area3D = $CollisionShape3D/Area3D

var move_direction: Vector3 = Vector3.ZERO
var time_until_change: float = 0.0
var is_dead: bool = false

func _ready():
	add_to_group("rat")
	#add_to_group("scrap") -will chnage, feels like cheating
	randomize()
	time_until_change = move_interval
	_change_direction()
	dead_mesh.visible = false
	area_detector.body_entered.connect(_on_body_entered)
	area_detector.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	time_until_change -= delta
	if time_until_change <= 0.0:
		_change_direction()
		time_until_change = move_interval

	if linear_velocity.length() < max_speed:
		apply_central_force(move_direction * move_force)

	angular_velocity = Vector3.ZERO

	if move_direction.length_squared() > 0.01:
		var forward = move_direction.normalized()
		look_at(global_transform.origin + forward, Vector3.UP)

func _change_direction() -> void:
	var angle = randf() * TAU
	move_direction = Vector3(cos(angle), 0, sin(angle)).normalized()

func _on_area_entered(area: Area3D) -> void:
	if is_dead:
		return
	if "hammer" in area.get_groups():
		_die()

func _on_body_entered(body: Node) -> void:
	if is_dead:
		return
	if "hammer" in body.get_groups():
		_die()

func _die() -> void:
	is_dead = true
	undead_mesh.visible = false
	dead_mesh.visible = true
	move_direction = Vector3.ZERO
	linear_velocity = Vector3.ZERO
