extends Sprite2D

class_name DustCloudAnimation

func start(pos : Vector2i, rot_deg : int, height : int) -> void:
	global_position = pos
	
	var tween : Tween = self.create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self, "rotation_degrees", rot_deg, 1)
	tween.tween_property(self, "global_position:y", height, 1)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	
	await tween.finished
	queue_free()

