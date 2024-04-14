extends CharacterBody2D
class_name playercharacter

#TODO has to be changed later to accomodate animations
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export_range(0, 400, 5) var speed : float = 165.0 #165
@export_range(0, 1, 0.1) var acceleration : float = 0.5
@export_range(0, 1000, 10) var jump_value : float = 430.0 #-430
var jump_velocity : float = -jump_value
@export_range(0, 1, 0.1) var friction : float = 0.5
@export_range(0, 1000, 10) var max_fall_speed : float = 400
@export var push_force: float = 150.0

var player_died : bool = false;

signal death

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5
var looking_direction : float
var picked_up_box : RigidBody2D

func jump() -> void:
	velocity.y = jump_velocity

func jump_cut() -> void:
	if velocity.y < 0:
		velocity.y = velocity.y / 2

#TODO break out into more funcs
func _physics_process(delta : float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += (default_gravity) * delta
		elif velocity.y < max_fall_speed:
			velocity.y += fast_fall_gravity * delta
		# Ensure fall speed past max_fall_speed is consistent
		else:
			velocity.y = max_fall_speed

	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal()*push_force)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
		
	if Input.is_action_just_released("ui_accept"):
		jump_cut()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : int = Input.get_axis("ui_left", "ui_right")

	if direction > 0:
		sprite_2d.flip_h = false;
	elif direction < 0:
		sprite_2d.flip_h = true;

	if direction != 0:
		looking_direction = direction

	# Check to make sure player doesn't slide more when running opposite way
	# There may be a better solution
	if (direction == 1 and velocity.x >= 0) or (direction == -1 and velocity.x <= 0):
		velocity.x = move_toward(velocity.x, direction * speed, (speed * 5) * acceleration * delta)
		if is_on_floor():
			animation_player.play("walk")
		else:
			animation_player.play("RESET")
	else:
		velocity.x = move_toward(velocity.x, 0, (speed * 10) * friction * delta)
		animation_player.play("RESET")
	move_and_slide()


func _on_health_death_signal():
	#freeze the physics process since the game is finished. If we move movement mechanics out of physics process, consider using the player_died variable
	set_physics_process(false)
	player_died = true;
	
	#make player invisible
	visible = false;
	scale = Vector2(0, 0);
	
	#signal the death screen to becomme visible
	emit_signal("death");
