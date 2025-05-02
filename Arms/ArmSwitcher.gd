extends Node3D

@onready var arm_joint: Marker3D = $ArmJoint
var current_arm: Node3D = null

func _ready():
	pass

func attach_arm(new_arm_scene: PackedScene):

	if current_arm:
		current_arm.queue_free()

	current_arm = new_arm_scene.instantiate()

	arm_joint.add_child(current_arm)

	current_arm.transform = Transform3D.IDENTITY

func remove_arm():
	if current_arm:
		current_arm.queue_free()
	current_arm = null
