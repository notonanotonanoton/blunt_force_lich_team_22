extends Area2D

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity") / 6
var movement_y : int = 0
const HEALTH_INCREASE : int = 2

#drop functionality untested

func _physics_process(delta : float) -> void:
	if movement_y > 0:
		movement_y += default_gravity
		global_position.y += movement_y * delta

func dropped() -> void:
	movement_y -= 300

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body is PlayerCharacter:
		body.get_node("Health").heal(HEALTH_INCREASE)
		queue_free()
	else:
		print(typeof(body))
		set_physics_process(false)



