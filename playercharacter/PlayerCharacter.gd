extends CharacterBody2D
class_name PlayerCharacter

#TODO has to be changed later to accomodate animations
#TODO: consider converting to enemy template
#TODO: assuming previous conditional is true, rename enemy template -> character template
@onready var player_sprites : Node2D = $PlayerSprites
@onready var animation_player = $AnimationPlayer

@export_range(0, 400, 5) var speed : float = 165.0 #165
@export_range(0, 1, 0.1) var acceleration : float = 0.5
@export_range(0, 1000, 10) var jump_value : float = 430.0 #-430
var jump_velocity : float = -jump_value
@export_range(0, 1, 0.1) var friction : float = 0.5
@export_range(0, 1000, 10) var max_fall_speed : float = 400


@export var coyote_timer : Timer
@export var coyote_time : float = 0.1

@export var velocity_timer : Timer
@export var velocity_time : float = 0.05

#coyote timer logic
var player_jumped : bool = false;
var jump_is_available : bool = true
var player_died : bool = false;

#box throwing logic
var charge_time : float = 0.0
var charging_throw : bool = false

signal request_box_status

signal death
signal step_taken

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5
var looking_direction : float
var picked_up_box : CharacterBody2D

func _ready() -> void:
	coyote_timer.one_shot = true
	coyote_timer.wait_time = coyote_time
	
	velocity_timer.one_shot = true
	velocity_timer.wait_time = velocity_time


func _physics_process(delta : float) -> void:
	
	_apply_gravity(delta)

	_process_jump_availability()
	
	_process_jump(delta)
		
	_process_movement(delta)
		
	move_and_slide()
	
	_process_throw(delta)



## jump functions
func jump() -> void:
	velocity.y = jump_velocity

func jump_cut() -> void:
	if velocity.y < 0:
		velocity.y = velocity.y / 2

func _process_jump(delta_time : float) -> void:
		# Handle jump. i couldn't figure out how to move this out
	if Input.is_action_just_pressed("ui_accept") and jump_is_available and not player_jumped:
		jump()
		player_jumped = true
		
	if Input.is_action_just_released("ui_accept"):
		jump_cut()
		

func _process_jump_availability() -> void:
	if not player_jumped and not velocity_timer.is_stopped():
		velocity.y = 0
		
	if not is_on_floor():
		if jump_is_available:
			if coyote_timer.is_stopped():
				velocity_timer.start()
				coyote_timer.start()
	else:
		jump_is_available = true
		player_jumped = false;







##box functions

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			emit_signal("request_box_status")


func _process_throw(delta_time : float) -> void:
	if Input.is_action_just_pressed("throw_box"):
		if picked_up_box != null:
			charging_throw = true
	
	if charging_throw:
		charge_time += delta_time
			
	if (Input.is_action_just_released("throw_box")):
		picked_up_box.throw(self, charge_time)
		charge_time = 0.0
		charging_throw = false



#this function checks if the parent of a hurtbox is allowed to deal damage. It must exist on ALL hurtbox instances
#it allows for custom conditionals of logic, such as the box having an arming time and velocity
#while maintaining maximum modularity in the health module in exchange for some boilerplate.
#for the player, since we currently (26/04/2024) do not have any conditions that the player can't do damage in
#it is always true
func can_deal_damage() -> bool:
	return true






##Movement functions 

func _apply_gravity(delta_time : float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += (default_gravity) * delta_time
		elif velocity.y < max_fall_speed:
			velocity.y += fast_fall_gravity * delta_time
		# Ensure fall speed past max_fall_speed is consistent
		else:
			velocity.y = max_fall_speed


func _process_movement(deltatime : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : int = Input.get_axis("ui_left", "ui_right")

	if (direction > 0 or direction < 0):
		player_sprites.scale.x = direction
		looking_direction = direction
		if (is_on_floor):
			emit_signal("step_taken")

	# Check to make sure player doesn't slide more when running opposite way
	# There may be a better solution
	if (direction == 1 and velocity.x >= 0) or (direction == -1 and velocity.x <= 0):
		velocity.x = move_toward(velocity.x, direction * speed, (speed * 5) * acceleration * deltatime)
	else:
		velocity.x = move_toward(velocity.x, 0, (speed * 10) * friction * deltatime)
		





##signal functions

func _on_health_death_signal() -> void:
	#freeze the physics process since the game is finished. If we move movement mechanics out of physics process, consider using the player_died variable
	set_physics_process(false)
	player_died = true;
	
	#make player invisible
	visible = false;
	scale = Vector2(0, 0);
	
	#signal the death screen to becomme visible
	emit_signal("death");


func _on_coyote_timer_timeout() -> void:
	jump_is_available = false;

func _on_velocity_freeze_timer_timeout() -> void:
	player_jumped = false;



func _on_area_2d_send_box_status(arg) -> void:

	#if we type-hint the arg type then we are not allowed to iterate over them
	for body in arg:
		if body is player_box:
			body.picked_up_by(self)
			picked_up_box = body
