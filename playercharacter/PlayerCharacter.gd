extends CharacterBody2D

class_name PlayerCharacter

@export_category("Nodes")
@export var player_sprites : Node2D
@export var animation_player : AnimationPlayer
@export var coyote_timer : Timer
@export var velocity_timer : Timer
@export var left_arm : Sprite2D
@export var right_arm : Sprite2D
@export var box_sprite : Sprite2D
@export var health_node : HealthComponent

@export_category("Values")
@export_range(0, 400, 5) var speed : float = 165.0
@export_range(0, 1, 0.1) var acceleration : float = 0.5
@export_range(-1000, 0, 10) var jump_velocity : float = -430.0
@export_range(0, 1, 0.1) var friction : float = 0.5
@export_range(0, 1000, 10) var max_fall_speed : float = 400
@export_range(0, 0.5, 0.1) var coyote_time : float = 0.1
@export_range(0, 0.1, 0.01) var velocity_time : float = 0.05
@export_range(350, 750, 25) var throw_force_x : int = 375
@export_range(-500, -250, 25) var throw_force_y : int = -275
@export_range(0.5, 3, 0.5) var throw_charge_rate : float = 1.5

#needed for healthmodule implementation
@export var can_deal_damage : bool = false

#coyote timer logic
var player_jumped : bool = false;
var jump_is_available : bool = true
var player_died : bool = false;

#box throwing logic
#charge_time has to start at 0.0 for code logic
var charge_time : float = 0.0
const charge_minimum : float = 0.3
var charging_throw : bool = false
const max_throw_anim_rot_deg : float = -20
var max_throw_force : = Vector2i(throw_force_x, throw_force_y)
var interact_released : bool = false
var throw_tween : Tween

signal player_death
signal step_taken
signal jumped
signal health_changed
signal max_health_changed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5

var picked_up_box : PlayerBox
var available_box : PlayerBox

func _ready() -> void:
	coyote_timer.wait_time = coyote_time
	velocity_timer.wait_time = velocity_time
	
	health_node.health_changed.connect(_on_health_changed)
	health_node.max_health_changed.connect(_on_max_health_changed)

func _physics_process(delta : float) -> void:
	
	_apply_gravity(delta)

	_process_jump_availability()
	
	_process_jump()
		
	_process_movement(delta)
	
	_process_throw(delta)
	
	move_and_slide()



## jump functions
func jump() -> void:
	velocity.y = jump_velocity
	emit_signal("jumped")

func jump_cut() -> void:
	if velocity.y < 0:
		velocity.y = velocity.y / 2

func _process_jump() -> void:
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
func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("interact_or_throw"):
		if not picked_up_box and available_box and available_box.is_on_floor():
			picked_up_box = available_box
			picked_up_box.pick_up(self)
			apply_carrying_sprites(true)

func _process_throw(delta : float) -> void:
	if picked_up_box:
		if Input.is_action_just_released("interact_or_throw"):
			interact_released = true
			if charge_time > 0.0:
				apply_carrying_sprites(false)
				#need to save charge_time as multiplier for Tweens because
				#of time sensitivity
				var multiplier = charge_time
				var direction : int = player_sprites.scale.x
				picked_up_box.throw(Vector2i(throw_force_x * direction, 
				throw_force_y) * charge_time)
				
				interact_released = false
				picked_up_box = null
				charge_time = 0.0
				
				if throw_tween:
					throw_tween.kill()
				throw_tween = self.create_tween()
				
				throw_tween.tween_property(player_sprites, "rotation_degrees",
				(-max_throw_anim_rot_deg) * direction, 0.1)
				throw_tween.tween_property(player_sprites, "rotation_degrees", 0, 0.5)
				
				multiplier = 0.0
				
		
		elif Input.is_action_pressed("interact_or_throw") and interact_released:
			charge_time += throw_charge_rate * delta
			charge_time = clampf(charge_time, charge_minimum, 1.0)
			player_sprites.rotation_degrees = lerpf(0.0,
			max_throw_anim_rot_deg * player_sprites.scale.x, charge_time)

func apply_carrying_sprites(apply : bool) -> void:
	if apply:
		right_arm.rotation_degrees = -45
		left_arm.rotation_degrees = 30
		left_arm.position.x += 1
		left_arm.position.y -= 1
		box_sprite.texture = picked_up_box.sprite.texture
	else:
		right_arm.rotation_degrees = 0
		left_arm.rotation_degrees = 0
		left_arm.position.x -= 1
		left_arm.position.y += 1
		box_sprite.texture = null


##Movement functions 

func _apply_gravity(delta : float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += default_gravity * delta
		elif velocity.y < max_fall_speed:
			velocity.y += fast_fall_gravity * delta
		# Ensure fall speed past max_fall_speed is consistent
		else:
			velocity.y = max_fall_speed


func _process_movement(delta : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : int = Input.get_axis("ui_left", "ui_right")

	if (direction > 0 or direction < 0):
		#this value is used by other code to get the player's direction
		if charge_time == 0:
			player_sprites.scale.x = direction
		if is_on_floor():
			emit_signal("step_taken")

	# Check to make sure player doesn't slide more when running opposite way
	# There may be a better solution
	if (direction == 1 and velocity.x >= 0) or (direction == -1 and velocity.x <= 0):
		velocity.x = move_toward(velocity.x, direction * speed, (speed * 5) * acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, (speed * 10) * friction * delta)
		


##signal functions

#takes in a redundant Vector2i. maybe separate signal?
func _on_health_death(position : Vector2i) -> void:
	#freeze the physics process since the game is finished. If we move movement mechanics out of physics process, consider using the player_died variable
	set_physics_process(false)
	#removes player detection from game. use better solution like export
	get_node("CollisionShape2D").set_deferred("disabled", true)
	player_died = true;
	
	#make player invisible
	player_sprites.visible = false
	#scale = Vector2(0, 0);
	
	#signal the death screen to becomme visible
	emit_signal("player_death");

func _on_coyote_timer_timeout() -> void:
	jump_is_available = false;

func _on_velocity_freeze_timer_timeout() -> void:
	player_jumped = false;

func _on_box_detector_body_entered(body : CharacterBody2D) -> void:
	if body is PlayerBox:
		available_box = body

func _on_box_detector_body_exited(body : CharacterBody2D) -> void:
	if body is PlayerBox:
		available_box = null

func _on_health_changed(health_change : int) -> void:
	if (!player_died): #slime keeps attacking after player death
		emit_signal("health_changed", health_change)

func _on_max_health_changed(max_health_change : int) -> void:
	emit_signal("max_health_changed", max_health_change)
