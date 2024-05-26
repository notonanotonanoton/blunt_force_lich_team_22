extends Node2D

class_name PickupPedestal

func place_item(item : Node2D) -> void:
	
	add_child(item)
	item.global_position = self.global_position+Vector2(0, -6)
