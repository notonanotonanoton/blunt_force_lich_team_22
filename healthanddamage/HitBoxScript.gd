extends Area2D
class_name hit_box_component

@export var parent : Node2D
@export_range(0, 10, 1) var damage : int = 1
var unbuffed_damage : int
var should_attack_slow : bool = false;

signal dealt_damage
signal request_active_items


#this is the area that deals damage

func _ready() -> void:
	unbuffed_damage = damage;

func _on_hit_box_entered(area : Area2D) -> void:
	if area is hurt_box_component:
		if parent.can_deal_damage:
			
			if parent is PlayerBox:
				for child : Node in parent.get_parent().get_children():
					if child is PlayerCharacter:
						should_attack_slow = child.does_player_have_slowing_item()
						

			emit_signal("dealt_damage", area.global_position)
			
			for child : Node in parent.get_children():
				if child is hurt_box_component:
					area.damage_with_return_possible(damage, global_position, child, should_attack_slow)
					return
			area.damage(damage, global_position, should_attack_slow)


func _on_area_exited(area : Area2D) -> void:
	if area is hurt_box_component:
		area.update_player_left()
