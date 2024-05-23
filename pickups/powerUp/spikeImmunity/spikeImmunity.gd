extends Node2D
class_name spikeImmunity



func _on_area_2d_body_entered(body : Node2D) -> void:
	if body is PlayerCharacter:
		body.addItem(self)
