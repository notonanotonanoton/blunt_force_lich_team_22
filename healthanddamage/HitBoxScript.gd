extends Area2D
class_name hit_box_component

@export_range(0, 10, 1) var damage : int = 1
var unbuffed_damage : int


#this is the area that the parent can take damage in

func _ready() -> void:
	unbuffed_damage = damage;

func _on_hit_box_entered(area : Area2D) -> void:
	if area is hurt_box_component:
		if get_parent().can_deal_damage:
			print(get_parent().velocity)
			area.damage(damage, global_position)
