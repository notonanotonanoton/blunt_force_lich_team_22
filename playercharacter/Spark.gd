extends Sprite2D

class_name SparkAnimation

func start(pos : Vector2i) -> void:
	global_position = pos
	
	var tween : Tween = self.create_tween()
	tween.set_parallel(true)
	
	#tween.tween_property(self, "rotation_degrees", 90, 0.2)
	tween.tween_property(self, "scale", Vector2(1.4, 1.1), 0.15)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	
	await tween.finished
	queue_free()
