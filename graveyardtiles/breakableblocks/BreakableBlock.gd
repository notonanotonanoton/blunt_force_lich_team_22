extends CharacterBody2D

class_name BreakableBlock

@export var is_rock : bool = true

@onready var pebble = preload("res://graveyardtiles/breakableblocks/FlyingPebble.tscn")

func _ready() -> void:
	pass

func damaged() -> void:
	var parent : Node2D = get_parent()
	var pos : Vector2 = global_position
	for count : int in range(1, 4):
		var new_pebble : FlyingPebble = pebble.instantiate()
		if not is_rock:
			new_pebble.swap_texture()
		parent.add_child(new_pebble)
		var dir : int = randi_range(0, 1)
		if dir == 0:
			dir = -1
		new_pebble.start(Vector2(pos.x - 16 + (count * 8), pos.y - (count * 8)), dir, 0.25 * count)

