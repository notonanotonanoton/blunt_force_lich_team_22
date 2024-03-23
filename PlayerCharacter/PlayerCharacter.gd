extends CharacterBody2D

#TODO has to be changed later to accomodate animations
@onready var sprite_2d = $Sprite2D

@export var speed : float = 300.0
@export var acceleration : float = 0.8
@export var jump_velocity : float = -430.0
@export var friction : float = 0.8
@export var max_fall_speed : float = 400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5


#TODO break out into more funcs
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += default_gravity * delta
		elif velocity.y < max_fall_speed:
			velocity.y += fast_fall_gravity * delta
		# Ensure fall speed past max_fall_speed is consistent
		else:
			velocity.y = max_fall_speed
		
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : float = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerpf(velocity.x, direction * speed, (10 * acceleration) * delta)
		if direction > 0:
			sprite_2d.flip_h = false;
		else:
			sprite_2d.flip_h = true;
	else:
		velocity.x = lerpf(velocity.x, 0, (25 * friction) * delta)

	move_and_slide()
