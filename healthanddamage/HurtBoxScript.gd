extends Area2D
class_name  hurt_box_component

@export var health_component : HealthComponent

#this is the area that recieves


func damage(damage_value : int, enemy_position : Vector2) -> void:
	#print("takes damage")
	if health_component:
		health_component.take_damage(damage_value, enemy_position, null)


func damage_with_return_possible(damage_value : int, enemy_position : Vector2, hurtcomponent : hurt_box_component):
	if health_component:
		health_component.take_damage(damage_value, enemy_position, hurtcomponent)

func update_player_left() -> void:
	if health_component:
		health_component.update_player_left_hitbox()
