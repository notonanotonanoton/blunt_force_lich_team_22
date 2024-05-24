extends Node2D
class_name Slow_Enemies

@export var slow : float = 0.3


func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		body.addItem(self)
