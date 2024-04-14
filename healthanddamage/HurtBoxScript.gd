extends Area2D
class_name  hit_box_component

@export var health_component : HealthComponent

func damage(damage : int, enemy_position : Vector2) -> void:
	if health_component:
		health_component.take_damage(damage, enemy_position)

