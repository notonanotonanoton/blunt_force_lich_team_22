extends Node2D
class_name ThornsItem

@export var thornsDamage : int = 1


func _on_area_2d_body_entered(body : Node2D) -> void:
	if body is PlayerCharacter:
		body.addItem(self.duplicate())
		queue_free()
		
