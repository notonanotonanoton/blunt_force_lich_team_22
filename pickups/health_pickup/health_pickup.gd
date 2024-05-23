extends Area2D

const HEALTH_INCREASE : int = 2

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is PlayerCharacter:
		body.get_node("Health").heal(HEALTH_INCREASE)
	queue_free()
