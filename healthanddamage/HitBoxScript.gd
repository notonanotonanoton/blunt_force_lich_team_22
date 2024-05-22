extends Area2D
class_name hit_box_component

@export_range(0, 10, 1) var damage : int = 1
var unbuffed_damage : int

signal dealt_damage


#this is the area that deals damage

func _ready() -> void:
	unbuffed_damage = damage;

func _on_hit_box_entered(area : Area2D) -> void:
	if area is hurt_box_component:
		if get_parent().can_deal_damage:

			emit_signal("dealt_damage", area.global_position)
			
			for child in get_parent().get_children():
				if child is hurt_box_component:
					area.damage_with_return_possible(damage, global_position, child, false)
					return
			
			area.damage(damage, global_position, false)


func _on_area_exited(area : Area2D) -> void:
	if area is hurt_box_component:
		area.update_player_left()
