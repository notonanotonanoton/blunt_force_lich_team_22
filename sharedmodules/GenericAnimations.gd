extends Node2D

@export_category("Nodes")
@export var parent_sprite : Node2D

@export_category("Values")

var damage_tween_flash : Tween
var damage_tween_shake : Tween

signal took_damage

func _ready() -> void:
	pass

func walk_animation() -> void:
	pass

#will have issues if called a second time before finishing,
#therefore the tweens are saved outside of the function and
#discarded if called too early
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
