extends Node2D
@export var timer : Timer


func _ready() -> void:
	timer.one_shot = true
	timer.autostart = false
	timer.start(0.2)


func _on_timer_timeout() -> void:
	for child in get_parent().get_children():
		print(child)
		if child is PlayerBox:
			child.global_position = child.global_position+Vector2(195, 0)
