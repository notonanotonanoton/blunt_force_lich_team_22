extends Node2D
class_name InvincibilityExtender

@export var extensionDuration : int = 0.5

func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		body.addItem(self.duplicate())
		queue_free()
