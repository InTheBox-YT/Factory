extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var selected = false
var player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and selected:
		player.pick_up_object(self)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.interact_object.connect(_set_selected)

func _process(delta: float) -> void:
	$CollisionShape3D.disabled = player == get_parent()

func _physics_process(delta: float) -> void:
	if player == get_parent(): return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	move_and_slide()

func _set_selected(object):
	selected = self == object
