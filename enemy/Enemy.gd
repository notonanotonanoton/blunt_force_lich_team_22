extends CharacterBody2D
class_name Enemy

@export_category("Nodes")
@export var aggro_radius : CollisionShape2D
@export var direction_flip : Node2D
@export var sprite : Sprite2D
@export var ground_detector : Area2D
@export var low_ground_detector : Area2D
@export var jump_block_detector : Area2D
@export var high_jump_block_detector : Area2D
@export var collision : CollisionShape2D
@export var behavior_extension : EnemyBehaviorExtension
@export var aggro_range_increase_timer : Timer
@export var hurtbox_collision : hurt_box_component
@export var slow_timer : Timer
@export var state_machine : StateMachine
#leave empty for non-skeleton
@export var skeleton_animation_timer : Timer

#some changes have been made here that should also be reflected in the player variables
@export_category("Values")
@export_range(0, 400, 5) var speed : int = 80

@export_range(0, 1, 0.1) var acceleration : float = 0.8
@export_range(-1000, 0, 10) var jump_velocity : int = -430
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1000, 10) var max_fall_speed : int = 350
@export_range(0, 2, 0.1) var gravity_scale : float = 1.0
@export_range(0, 300, 10) var aggro_range : int = 120
@export var is_ranged : bool = false
#needed for healthmodule implementation
@export var can_deal_damage : bool = true
@export var slow_time : int = 3

var max_speed : int
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5
var collision_offset : int
var is_slowed : bool = false;
var health_pickup : PackedScene = preload("res://pickups/health_pickup/health_pickup.tscn")
var is_attacking : bool = false


#used to prevent pathfinding getting stuck on walls 
#when there's a tile 1 tile above
var was_on_wall : bool = false

#is -1 for left or 1 for right. starts as right.
#has to have the same variable name as PlayerCharacter
var looking_direction : int = 1:
	set(new_direction):
		if looking_direction != new_direction and (new_direction == 1 or new_direction == -1):
			looking_direction = new_direction
			direction_flip.scale.x = new_direction

var target_player : PlayerCharacter = null

signal step_taken
signal jumped

#many functions are called in states inside the state machine

func _ready() -> void:
	max_speed = speed;
	aggro_radius.shape.radius = aggro_range
	collision_offset = (collision.shape.get_rect().size.x + 1) / 2 
	slow_timer.wait_time = slow_time

func _physics_process(delta : float) -> void:
	apply_gravity(delta)
	if ((looking_direction == 1 and velocity.x < 0) or
	 (looking_direction == -1 and velocity.x > 0)):
		stop_move(delta)
	if state_machine:
		state_machine.physics_update(delta)
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

func jump(delta : float, jump_mult : float, jump_action : bool) -> void:
	velocity.y = jump_velocity * jump_mult
	emit_signal("jumped")
	if behavior_extension and jump_action:
		behavior_extension.jump_action(delta)

func move(delta : float, move_mult : float) -> void:
	velocity.x = move_toward(velocity.x, looking_direction * speed * move_mult, (speed * 2) * acceleration * delta)
	if is_on_floor():
		emit_signal("step_taken")
		handle_wall_or_gap(delta)

func stop_move(delta : float) -> void:
	velocity.x = move_toward(velocity.x, 0, (speed * 8) * friction * delta)

func handle_wall_or_gap(delta : float) -> void:
	if not ground_detector.has_overlapping_bodies():
		#acts as extension of aggro behavior
		if target_player != null:
			chase_jump(delta)
		
		elif not low_ground_detector.has_overlapping_bodies():
			looking_direction *= -1
			
			
	#currently this makes the enemy jump when it's against a wall and
	#looking_direction *= -1 is called. this may be left as is or fixed in the future
	elif(is_on_wall()):
		if has_all_jump_overlap() and target_player == null:
			if not was_on_wall:
				looking_direction *= -1
				was_on_wall = true
		else:
			jump(delta, 1.0, false)
	else:
		was_on_wall = false

func damage_aggro_range_increase() -> void:
	#this should get immediately overwritten by EnemyAggro's enter()
	if target_player == null:
		aggro_radius.shape.radius *= 10

func has_all_jump_overlap() -> bool:
	if jump_block_detector.has_overlapping_bodies() and high_jump_block_detector.has_overlapping_bodies():
		return true
	else:
		return false

func activate_death_state() -> void:
	set_physics_process(false)
	collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)
	drop_health_pickup()
	if skeleton_animation_timer:
		skeleton_animation_timer.paused = true

func drop_health_pickup() -> void:
	#25% chance
	if randi_range(0, 3) == 3:
		var drop : HealthPickup = health_pickup.instantiate()
		get_parent().add_child.call_deferred(drop)
		drop.dropped(global_position)

func chase_jump(delta : float) -> void:
	if (global_position.y + 34 > target_player.global_position.y):
		if abs(global_position.x - target_player.global_position.x) > 54:
				jump(delta, 1.1, false)
				velocity.x = 150 * looking_direction
				if slow_timer.is_stopped():
					#apply slow with slow timer
					pass
		else:
			jump(delta, 1.0, false)

	if not is_attacking:
		if (global_position.y + 36 > target_player.global_position.y):
			if abs(global_position.x - target_player.global_position.x) > 54:
					jump(delta, 1.1, false)
					velocity.x = 165 * looking_direction
					if slow_timer.is_stopped():
						#apply slow with slow timer
						pass
			else:
				print("chase jumped")
				jump(delta, 1.0, false)



func _on_slow_timer_timeout():
	for child in get_children():
		if child is StateMachine:
			for subchild in child.get_children():
				if subchild is enemy_aggro:
					subchild.attack_rate = subchild.max_attack_rate




func _on_slowed():
	is_slowed = true;
	print("slowing: ")
	for child in get_children():
		if child is StateMachine:
			for subchild in child.get_children():
				if subchild is enemy_aggro:
					subchild.attack_rate = subchild.attack_rate*1.5
					
	slow_timer.start()
