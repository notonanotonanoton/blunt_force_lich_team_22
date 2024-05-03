extends Node2D
class_name arrow

var can_deal_damage : bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Vector2.LEFT * 200 * delta
