extends Node

@export var player_character : CharacterBody2D
const HEALTH_INCREASE : int = 2

func _on_health_pickup_box_body_entered(body):
	if body is PlayerCharacter:
		body.get_node("Health").heal(HEALTH_INCREASE)
	queue_free()
