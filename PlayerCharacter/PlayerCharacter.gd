extends CharacterBody2D

signal request_box_status

#TODO has to be changed later to accomodate animations
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export var speed : float = 165.0 #165
@export var acceleration : float = 0.5
@export var jump_velocity : float = -430.0 #-430
@export var friction : float = 0.5
@export var max_fall_speed : float = 400
@export var push_force: float = 150.0
var picked_up_box : RigidBody2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5
var looking_direction : float
#func _ready():
#	

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			emit_signal("request_box_status")
		if event.pressed and event.keycode == KEY_T:
			if picked_up_box != null:
				picked_up_box.throw(self)

func jump():
	velocity.y = jump_velocity

func jump_cut():
	if velocity.y < 0:
		velocity.y = velocity.y / 2

#TODO break out into more funcs
func _physics_process(delta):
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
	var direction : float = Input.get_axis("ui_left", "ui_right")

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
			animation_player.stop()
	else:
		velocity.x = move_toward(velocity.x, 0, (speed * 10) * friction * delta)

	move_and_slide()

func _on_area_2d_send_box_status(arg2):
	for body in arg2:
		if body.name == "pick_up_box":
			body.pick_up(self)
			picked_up_box = body

