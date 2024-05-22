extends Node2D
class_name ThornsItem

@export var thornsDamage = 1


func _on_area_2d_body_entered(body):
	print(body)
	if body is PlayerCharacter:
		body.addItem(self)
		
