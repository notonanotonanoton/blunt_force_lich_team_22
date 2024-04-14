extends Area2D
class_name hurt_box_component

@export var damage : int = 1
var unbuffed_damage : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unbuffed_damage = damage;

func _on_hit_box_entered(area : Area2D) -> void:
	if area is hit_box_component:
		area.damage(damage, global_position)
