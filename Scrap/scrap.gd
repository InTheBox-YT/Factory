extends RigidBody3D

@onready var death_detector: Area3D = $Area3D
@export var scrap_type: String = "metal_a"

func _ready() -> void:	
	add_to_group("scrap")
	death_detector.body_entered.connect(_on_death_detector_body_entered)

func _on_death_detector_body_entered(body: Node) -> void:
	if body.is_in_group("PartDeath"):
		queue_free()
