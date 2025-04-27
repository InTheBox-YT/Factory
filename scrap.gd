extends RigidBody3D

@onready var death_detector: Area3D = $Area3D

func _ready() -> void:
	death_detector.body_entered.connect(_on_death_detector_body_entered)

func _on_death_detector_body_entered(body: Node) -> void:
	if body.is_in_group("PartDeath"):
		queue_free()
