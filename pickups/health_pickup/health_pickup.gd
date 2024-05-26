extends Area2D

class_name HealthPickup

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity") / 6
var movement_y : int = 0
var was_dropped : bool = false
const HEALTH_INCREASE : int = 2

func _physics_process(delta : float) -> void:
	if was_dropped:
		movement_y += default_gravity * delta
		global_position.y += movement_y * delta

func dropped(pos : Vector2) -> void:
	global_position = pos
	was_dropped = true
	movement_y -= 100

func _on_body_entered(body : Node2D) -> void:
	if body is PlayerCharacter:
		body.health_node.heal(HEALTH_INCREASE)
		queue_free()
	elif not was_dropped or (body is TileMap and movement_y > 95):
		set_physics_process(false)



