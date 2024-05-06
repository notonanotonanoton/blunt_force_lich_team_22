extends Line2D
class_name Aiming_Arc

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_trajectory(dir : Vector2, delta : float):
	var max_points = 150
	clear_points()
	var pos : Vector2 = Vector2.ZERO
	for point in range(max_points):
		#print("added point at pos: ", pos)
		add_point(pos)
		dir.y += default_gravity * delta
		pos += dir * delta 

