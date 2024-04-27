extends CharacterBody2D
class_name Enemy

@export_category("Nodes")
@export var aggro_radius : CollisionShape2D
@export var direction_flip : Node2D
@export var sprite : Sprite2D
@export var ground_detector : Area2D
@export var low_ground_detector : Area2D
@export var jump_block_detector : Area2D
@onready var animation : AnimationPlayer = $AnimationPlayer

#some changes have been made here that should also be reflected in the player variables
@export_category("Values")
@export_range(0, 10, 0.5) var highJumpTime : float = 5
@export_range(0, 400, 5) var speed : float = 100.0
@export_range(0, 1, 0.1) var acceleration : float = 0.8
@export_range(-1000, 0, 10) var jump_velocity : float = -320.0
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1000, 10) var max_fall_speed : float = 400.0
@export_range(0, 2, 0.1) var gravity_scale : float = 1.0
@export_range(0, 200, 10) var aggro_range : int = 80

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5

#is -1 for left or 1 for right. starts as right
var move_direction : int = 1:
	set(new_direction):
		if(new_direction == 1 or new_direction == -1 and move_direction != new_direction):
			move_direction = new_direction
			direction_flip.scale.x = new_direction

var target_player : PlayerCharacter = null

#this function checks if the parent of a hurtbox is allowed to deal damage. It must exist on ALL hurtbox parent instances
func can_deal_damage() -> bool:
	return true

#many functions are called in states inside the state machine

func _ready() -> void:
	aggro_radius.shape.radius = aggro_range

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	move_and_slide()
	if is_on_ceiling():
		animation.play("flipped")
	else:
		animation.play("unflipped")

func apply_gravity(delta : float) -> void:
	if not is_on_floor():
		if is_on_ceiling() and target_player == null:
			velocity.y = 0
		elif velocity.y < 0:
			velocity.y += (default_gravity * gravity_scale) * delta
		elif velocity.y < max_fall_speed:
			velocity.y += (fast_fall_gravity * gravity_scale) * delta
		# Ensure fall speed past max is consistent
		else:
			velocity.y = max_fall_speed

func jump() -> void:
	velocity.y = jump_velocity
	
func highJump() -> void:
	velocity.y = jump_velocity*2

func move(delta : float) -> void:
	velocity.x = move_toward(velocity.x, move_direction * speed, (speed * 2) * acceleration * delta)
	if(is_on_floor()):
		handle_wall_or_gap()
		if ((move_direction == 1 and velocity.x < 0) or
	 (move_direction == -1 and velocity.x > 0)):
			stop_move(delta)

func stop_move(delta : float) -> void:
	velocity.x = move_toward(velocity.x, 0, (speed * 3) * friction * delta)

func handle_wall_or_gap() -> void:
	if(not ground_detector.has_overlapping_bodies()):
		if(not low_ground_detector.has_overlapping_bodies()):
			move_direction *= -1
	
	#currently this makes the enemy jump when it's against a wall and
	#move_direction *= -1 is called. this may be left as is or fixed in the future
	elif(is_on_wall()):
		if(jump_block_detector.has_overlapping_bodies()):
			move_direction *= -1
		else:
			jump()
