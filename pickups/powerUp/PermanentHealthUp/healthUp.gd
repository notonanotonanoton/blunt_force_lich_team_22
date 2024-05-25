extends Node2D
class_name PermanentHealthPickup

@export var amount_of_plus_health :  int = 2


func _on_area_2d_body_entered(body):
	if body is PlayerCharacter:
		body.addItem(self.duplicate())
		queue_free()
