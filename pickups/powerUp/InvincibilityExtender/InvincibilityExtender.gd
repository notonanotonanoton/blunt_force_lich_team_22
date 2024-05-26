extends Node2D
class_name InvincibilityExtender

@export var extensionDuration : float = 0.5

func _on_area_2d_body_entered(body : Node2D) -> void:
	if body is PlayerCharacter:
		body.addItem(self.duplicate())
		queue_free()
