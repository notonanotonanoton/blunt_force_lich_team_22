extends Area2D
class_name hurt_box_component

@export var damage = 1
var unbuffed_damage

# Called when the node enters the scene tree for the first time.
func _ready():
	unbuffed_damage = damage;

func _on_hit_box_entered(area):
	if area is hit_box_component:
		area.damage(damage, global_position)
