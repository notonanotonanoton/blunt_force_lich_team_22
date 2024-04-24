extends Node2D

@export_category("Nodes")
@export var parent_sprite : Sprite2D
@export var frame_duration_timer : Timer

@export_category("Values")

const red_brightness_default : float = 3.0
const green_and_blue_brightness_default : float = 3.0
const frame_duration_default : float = 0.0


signal took_damage

func walk_animation() -> void:
	pass

func take_damage_animation() -> void:
	var red_brightness : float = red_brightness_default
	var green_and_blue_brightness : float = green_and_blue_brightness_default
	var frame_duration : float = frame_duration_default
	frame_duration_timer.start()
	parent_sprite.modulate = create_monochrome_color(red_brightness, green_and_blue_brightness)
	var sprite_offset : int = 2
	for frame : int in range(1, 5, 1):
		#if (frame > 3):
			#sprite_offset = 1
		red_brightness -= 0.5
		if (green_and_blue_brightness > 1):
			green_and_blue_brightness -= 1
		frame_duration += 0.05
		parent_sprite.modulate = create_monochrome_color(red_brightness, green_and_blue_brightness)
		if (frame % 2 == 0):
			parent_sprite.position.x = 0
		else:
			parent_sprite.position.x = sprite_offset
			sprite_offset = -sprite_offset
		await frame_duration_timer.timeout
		frame_duration_timer.start(frame_duration)
	parent_sprite.position.x = 0
	

func create_monochrome_color(red : float, green_and_blue : float) -> Color:
	return Color(red, green_and_blue, green_and_blue)


func _on_health_taken_damage():
	take_damage_animation()
