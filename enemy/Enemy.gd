extends CharacterBody2D
class_name Enemy

@export_category("Nodes")
@export var aggro_radius : CollisionShape2D
@export var direction_flip : Node2D
@export var sprite : Sprite2D
@export var ground_detector : Area2D
@export var low_ground_detector : Area2D
@export var jump_block_detector : Area2D

#some changes have been made here that should also be reflected in the player variables
@export_category("Values")
@export_range(0, 400, 5) var speed : float = 80.0
@export_range(0, 1, 0.1) var acceleration : float = 0.8
@export_range(-1000, 0, 10) var jump_velocity : float = -350.0
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1000, 10) var max_fall_speed : float = 400.0
@export_range(0, 2, 0.1) var gravity_scale : float = 1.0
@export_range(0, 200, 10) var aggro_range : int = 80
#needed for healthmodule implementation
@export var can_deal_damage : bool = true

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5

#is -1 for left or 1 for right. starts as right.
#has to have the same variable name as PlayerCharacter
var looking_direction : int = 1:
	set(new_direction):
		if(new_direction == 1 or new_direction == -1 and looking_direction != new_direction):
			looking_direction = new_direction
			direction_flip.scale.x = new_direction

var target_player : PlayerCharacter = null

signal step_taken
signal jumped

#many functions are called in states inside the state machine

func _ready() -> void:
	aggro_radius.shape.radius = aggro_range

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	if is_on_floor():
		if ((looking_direction == 1 and velocity.x < 0) or
	 (looking_direction == -1 and velocity.x > 0)):
			stop_move(delta)
			
	move_and_slide()

func apply_gravity(delta : float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += (default_gravity * gravity_scale) * delta
		elif velocity.y < max_fall_speed:
			velocity.y += (fast_fall_gravity * gravity_scale) * delta
		# Ensure fall speed past max is consistent
		else:
			velocity.y = max_fall_speed

func jump(jump_mult : float) -> void:
	velocity.y = jump_velocity * jump_mult

func move(delta : float, move_mult : float) -> void:
	velocity.x = move_toward(velocity.x, looking_direction * speed * move_mult, (speed * 2) * acceleration * delta)
	if(is_on_floor()):
		emit_signal("step_taken")
		handle_wall_or_gap()

func stop_move(delta : float) -> void:
	velocity.x = move_toward(velocity.x, 0, (speed * 5) * friction * delta)

func handle_wall_or_gap() -> void:
	if(not ground_detector.has_overlapping_bodies()):
		if(not low_ground_detector.has_overlapping_bodies()):
			looking_direction *= -1
	
	#currently this makes the enemy jump when it's against a wall and
	#move_direction *= -1 is called. this may be left as is or fixed in the future
	elif(is_on_wall()):
		if(jump_block_detector.has_overlapping_bodies()):
			looking_direction *= -1
		else:
			jump(1.0)
