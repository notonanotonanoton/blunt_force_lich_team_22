extends Node2D

class_name GenericAnimations

@export_category("Nodes")
@export var animation_target : Node2D
@export var health_node : HealthComponent
@export var character : CharacterBody2D
@export var death_dust_cloud_fg : PackedScene
@export var death_dust_cloud_bg : PackedScene

@export_category("Values")
@export_range(0, 10, 1) var walk_rotation_degree : int = 5
@export_range(-10, 0, 1) var walk_step_height : int = -3

var not_actor : bool = false

var damage_tween_flash : Tween
var damage_tween_shake : Tween

var walk_step : Tween
var walk_rotation : Tween

var jump_squish : Tween

func _ready() -> void:
	health_node.damage_taken.connect(_on_damage_taken)
	health_node.death.connect(_on_death)
	if not character is BreakableBlock:
		character.step_taken.connect(_on_step_taken)
		character.jumped.connect(_on_jumped)
	else:
		not_actor = true

#will have issues if called a second time before finishing,
#therefore the tweens are saved outside of the function and
#the function is exited if called too early. exiting is 
#preferred here to ensure the animation ends sooner after
#movement stops
func walk_animation() -> void:
	if (walk_step or walk_rotation):
		if (walk_step.is_running()):
			return
		if (walk_rotation.is_running()):
			return
	walk_step = self.create_tween()
	walk_rotation = self.create_tween()
	
	var height : int = walk_step_height
	var degree : int = walk_rotation_degree
	
	#has to end on an uneven number or else position.y
	#will be unsynced after end of animation
	for frame : int in range(1, 3):
		if (frame % 2 == 0):
			degree = 0
			height = 0
		else:
			height = walk_step_height
			walk_rotation_degree *= -1
			degree = walk_rotation_degree
		walk_rotation.tween_property(animation_target, "rotation_degrees", degree, 0.1)
		walk_step.tween_property(animation_target, "position:y", 
		height, 0.1)
	

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
	
	animation_target.modulate = Color(3, 3, 3)
	damage_tween_flash.tween_property(animation_target, "modulate", Color(2, 1, 1), 0.2)
	damage_tween_flash.tween_property(animation_target, "modulate", Color(1, 1, 1), 0.2)
	damage_tween_flash.set_parallel(true)
	for frame : int in range(1, 5, 1):
		if (frame % 2 == 0):
			shake_duration += 0.05
		sprite_offset *= -1
		damage_tween_shake.tween_property(animation_target, "position:x", sprite_offset, shake_duration)
	
	if not_actor:
		character.damaged()

func jump_animation() -> void:
	if (walk_step or walk_rotation):
		walk_step.kill()
		walk_rotation.kill()
		animation_target.position.y = 0
		animation_target.rotation_degrees = 0
	
	if (jump_squish):
		jump_squish.kill()
	jump_squish = self.create_tween()
	
	animation_target.scale.x = 1.4
	animation_target.scale.y = 0.8
	animation_target.position.y = 2
	jump_squish.tween_property(animation_target, "position:y", 0, 0.2)
	jump_squish.parallel().tween_property(animation_target, "scale", Vector2(0.9, 1.1), 0.2)
	jump_squish.tween_property(animation_target, "scale", Vector2(1, 1), 0.1).set_delay(0.1)

#queue_free is handled here instead
func death_animation(pos : Vector2i) -> void:
	take_damage_animation()
	await damage_tween_shake.finished
	
	var parent : CharacterBody2D = get_parent()
	var root : Node2D = parent.get_parent()
	var fg_instance : DustCloudAnimation = death_dust_cloud_fg.instantiate()
	var bg_instance : DustCloudAnimation = death_dust_cloud_bg.instantiate()
	
	root.add_child(fg_instance)
	root.add_child(bg_instance)
	
	fg_instance.start(pos, -30, pos.y - 40)
	bg_instance.start(pos, 45, pos.y - 40)
	
	if parent is PlayerCharacter:
		parent.sprite.visible = false
	else:
		parent.queue_free()

func _on_damage_taken() -> void:
	take_damage_animation()

func _on_step_taken() -> void:
	walk_animation()

func _on_jumped() -> void:
	jump_animation() 

func _on_death(pos : Vector2i) -> void:
	death_animation(pos)
