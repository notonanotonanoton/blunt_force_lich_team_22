extends Area2D
class_name hit_box_component

@export var damage : int = 1
var unbuffed_damage : int

#this is the area that the parent can damage enemies in

func _ready() -> void:
	unbuffed_damage = damage;

func _on_hit_box_entered(area : Area2D) -> void:
	if area is hurt_box_component:
		area.damage(damage, global_position)
