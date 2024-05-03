extends Area2D
class_name  hurt_box_component

@export var health_component : HealthComponent

#this is the area that recieves


func damage(damage : int, enemy_position : Vector2) -> void:
	#print("takes damage")
	if health_component:
		health_component.take_damage(damage, enemy_position)

func update_player_left():
	if health_component:
		health_component.update_player_left_hitbox()
