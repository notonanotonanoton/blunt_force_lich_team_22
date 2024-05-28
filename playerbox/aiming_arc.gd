extends Line2D
class_name Aiming_Arc

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass

func display_trajectory(dir : Vector2, delta : float) -> void:
	var max_points : int = 150
	clear_points()
	var pos : Vector2 = Vector2.ZERO
	for point : int in range(max_points):
		add_point(pos)
		dir.y += default_gravity * delta
		pos += dir * delta 

