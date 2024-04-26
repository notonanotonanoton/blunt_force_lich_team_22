extends Node2D

class_name GenericAnimations

@export_category("Nodes")
@export var parent_sprite : Node2D

@export_category("Values")
@export_range(0, 10, 1) var walk_rotation_degree : int = 5
@export_range(0, 10, 1) var walk_step_height : int = 5

var damage_tween_flash : Tween
var damage_tween_shake : Tween

var walk_step : Tween
var walk_rotation : Tween

func _ready() -> void:
	pass

#will have issues if called a second time before finishing,
#therefore the tweens are saved outside of the function and
#discarded if called too early.
func walk_animation() -> void:
	if (walk_step or walk_rotation):
		walk_step.kill()
		walk_rotation.kill()
	walk_step = self.create_tween()
	walk_rotation = self.create_tween()
	
	var rotation_offset : int = walk_rotation_degree
	var degree : int = rotation_offset
	
	var default_sprite_position : int = parent_sprite.position.y
	
	#has to end on an even number or else position.y
	#will be unsynced after end of animation
	for frame : int in range(1, 4):
		if (frame % 2 == 0):
			degree = 0
			walk_step_height
		else:
			degree = walk_rotation_degree
			degree *= -1
		walk_rotation.tween_property(parent_sprite, "rotation", walk_rotation, 0.1)
		walk_rotation.parallel().tween_property(parent_sprite, "position:y", 
		default_sprite_position + walk_step_height, 0.1)
	

#will have issues if called a second time before finishing,
#therefore the tweens are saved outside of the function and
#discarded if called too early.
func take_damage_animation() -> void:
	if (damage_tween_flash or damage_tween_shake):
		damage_tween_flash.kill()
		damage_tween_shake.kill()
		
	damage_tween_flash = self.create_tween()
	damage_tween_shake = self.create_tween()
	var sprite_offset : int = 1
	var shake_duration : float = 0.00
	
	parent_sprite.modulate = Color(3, 3, 3)
	damage_tween_flash.tween_property(parent_sprite, "modulate", Color(2, 1, 1), 0.2)
	damage_tween_flash.tween_property(parent_sprite, "modulate", Color(1, 1, 1), 0.2)
	damage_tween_flash.set_parallel(true)
	for frame : int in range(1, 5, 1):
		if (frame % 2 == 0):
			shake_duration += 0.05
		sprite_offset *= -1
		damage_tween_shake.tween_property(parent_sprite, "position:x", sprite_offset, shake_duration)

func _on_health_taken_damage() -> void:
	take_damage_animation()

func _on_step_taken() -> void:
	walk_animation()
