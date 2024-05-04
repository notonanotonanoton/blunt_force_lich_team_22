extends CharacterBody2D
class_name Enemy

@export_category("Nodes")
@export var aggro_radius : CollisionShape2D
@export var direction_flip : Node2D
@export var sprite : Sprite2D
@export var ground_detector : Area2D
@export var low_ground_detector : Area2D
@export var jump_block_detector : Area2D
@export var collision : CollisionShape2D
@export var behavior_extension : EnemyBehaviorExtension

#some changes have been made here that should also be reflected in the player variables
@export_category("Values")
@export_range(0, 400, 5) var speed : int = 80
@export_range(0, 1, 0.1) var acceleration : float = 0.8
@export_range(0, 1000, 10) var jump_velocity : int = 430
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1000, 10) var max_fall_speed : int = 400
@export_range(0, 2, 0.1) var gravity_scale : float = 1.0
@export_range(0, 200, 10) var aggro_range : int = 100
#needed for healthmodule implementation
@export var can_deal_damage : bool = true

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5
var collision_offset : int

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

signal cant_chase

#many functions are called in states inside the state machine

func _ready() -> void:
	aggro_radius.shape.radius = aggro_range
	collision_offset = (collision.shape.get_rect().size.x + 1) / 2 

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	if ((looking_direction == 1 and velocity.x < 0) or
	 (looking_direction == -1 and velocity.x > 0)):
		stop_move(delta)
			
	move_and_slide()

func apply_gravity(delta : float) -> void:
	if not is_on_floor():
		if up_direction.y == -1 and velocity.y < 0:
			velocity.y += (default_gravity * gravity_scale) * delta
		elif up_direction.y == 1 and velocity.y > 0:
			velocity.y -= (default_gravity * gravity_scale) * delta
		elif velocity.y < max_fall_speed:
			print("this")
			velocity.y += ((fast_fall_gravity * gravity_scale) * (up_direction.y * -1)) * delta
		# Ensure fall speed past max is consistent
		else:
			velocity.y = max_fall_speed * (up_direction.y * -1)

func jump(delta : float, jump_mult : float, jump_action : bool) -> void:
	velocity.y = (jump_velocity * up_direction.y) * jump_mult
	if jump_action and behavior_extension:
		behavior_extension.jump_action(delta)

func move(delta : float, move_mult : float) -> void:
	velocity.x = move_toward(velocity.x, looking_direction * speed * move_mult, (speed * 2) * acceleration * delta)
	if(is_on_floor()):
		emit_signal("step_taken")
		handle_wall_or_gap(delta)

func stop_move(delta : float) -> void:
	velocity.x = move_toward(velocity.x, 0, (speed * 8) * friction * delta)

func handle_wall_or_gap(delta : float) -> void:
	if(not ground_detector.has_overlapping_bodies()):
		#this check is dependent on EnemyAggro temporarily changing the radius
		if(not low_ground_detector.has_overlapping_bodies() and aggro_radius.shape.radius == aggro_range):
				looking_direction *= -1
	
	#currently this makes the enemy jump when it's against a wall and
	#lookinig_direction *= -1 is called. this may be left as is or fixed in the future
	elif(is_on_wall()):
		if(jump_block_detector.has_overlapping_bodies() and not aggro_radius.shape.radius == aggro_range):
			looking_direction *= -1
		else:
			jump(delta, 1.0, false)

#CURRENTLY BUGS OUT ABILITY TO TAKE DAMAGE
func flip_gravity(flip : bool) -> void:
	if flip:
		up_direction.y = 1
		direction_flip.scale.y = -1
		direction_flip.position.y = (sprite.texture.get_height() * 2) / 3 - 1
	else:
		up_direction.y = -1
		direction_flip.scale.y = 1
		direction_flip.position.y = 0
