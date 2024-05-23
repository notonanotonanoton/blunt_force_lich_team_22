extends Sprite2D

class_name FlyingPebble

@export_category("Nodes")
@export var pebble_texture_rock : CompressedTexture2D
@export var pebble_texture_stone : CompressedTexture2D

func swap_texture(swap : bool) -> void:
	if swap:
		texture = pebble_texture_stone
	else:
		texture = pebble_texture_rock

func start(pos : Vector2, direction : int, speed : float) -> void:
	global_position = pos
	
	var duration : float = speed / 2
	
	var tween : Tween = self.create_tween()
	
	tween.tween_property(self, "global_position:y", pos.y - (30 * speed), duration)
	tween.parallel().tween_property(self, "rotation_degrees", (270 * speed) * direction, duration)
	tween.parallel().tween_property(self, "global_position:x", pos.x + ((40 * speed) * direction), duration)
	
	await tween.finished
	pos = global_position
	tween = self.create_tween()
	tween.tween_property(self, "global_position:y", pos.y + (50 * speed), duration)
	tween.parallel().tween_property(self, "rotation_degrees", (360 * speed) * direction, duration)
	tween.parallel().tween_property(self, "global_position:x", pos.x + ((15 * speed) * direction), duration)
	tween.parallel().tween_property(self, "modulate", Color(1,1,1,0), duration)
	
	await tween.finished
	queue_free()
