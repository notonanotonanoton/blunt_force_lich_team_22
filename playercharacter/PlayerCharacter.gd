extends CharacterBody2D

class_name PlayerCharacter

@export_category("Nodes")
#scale.x used for direction, among other things
@export var sprite : Node2D
#has to be used over player_sprites when manipulating scale.x outside of direction change
@export var animation_target : Node2D
@export var coyote_timer : Timer
@export var left_arm : Sprite2D
@export var right_arm : Sprite2D
@export var box_sprite : Sprite2D
@export var health_node : HealthComponent
@export var collision : CollisionShape2D
@export var hurtbox_collision : CollisionShape2D
@export var aiming_arc : Aiming_Arc
@export var camera : Camera2D
@export var resetting_jump_timer : Timer

@export_category("Values")
@export_range(0, 400, 5) var speed : int = 145
@export_range(0, 1, 0.1) var acceleration : float = 0.8
@export_range(-1000, 0, 10) var jump_velocity : int = -430
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1000, 10) var max_fall_speed : int = 350
@export_range(0, 0.5, 0.1) var coyote_time : float = 0.1
@export_range(250, 750, 25) var throw_force_x : int = 300
@export_range(-500, -250, 25) var throw_force_y : int = -275
@export_range(0.5, 3, 0.5) var throw_charge_rate : float = 1.5
@export_range(0.05, 0.5, 0.05) var stop_resetting_jump_status_time : float = 0.1
#needed for healthmodule implementation
@export var can_deal_damage : bool = false

@onready var spark_animation : PackedScene = preload("res://playercharacter/Spark.tscn")

#coyote timer logic
var player_jumped : bool = false
var jump_is_available : bool = true
var player_died : bool = false
var aiming_arc_enabled : bool = true

#box throwing logic
#charge_time has to start at 0.0 for code logic
var charge_time : float = 0.0
const charge_minimum : float = 0.4
var charging_throw : bool = false
const max_throw_anim_rot_deg : float = -20
var max_throw_force : Vector2i = Vector2i(throw_force_x, throw_force_y)
var interact_released : bool = false
var throw_tween : Tween
var is_channeling : bool = false

var allow_jump_variable_resets : bool = true 

var items : Array[Node]


signal player_death
signal step_taken
signal jumped
signal health_changed
signal max_health_changed
signal new_item

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var fast_fall_gravity : int = default_gravity * 1.5

@onready var box_ref : PlayerBox = load("res://playerbox/PlayerBox.tscn").instantiate()
var picked_up_box : bool = false
var available_box : PlayerBox

func _ready() -> void:
	coyote_timer.wait_time = coyote_time
	resetting_jump_timer.wait_time = stop_resetting_jump_status_time
	health_node.health_changed.connect(_on_health_changed)
	health_node.max_health_changed.connect(_on_max_health_changed)
	get_parent().add_child.call_deferred(box_ref)

func _physics_process(delta : float) -> void:
	move_and_slide()
	
	process_jump_availability()
	
	apply_gravity(delta)
	
	process_movement(delta)
	
	process_throw(delta)



## jump functions
func jump() -> void:
	allow_jump_variable_resets = false
	resetting_jump_timer.start()
	velocity.y = jump_velocity
	emit_signal("jumped")
	player_jumped = true

	

func jump_cut() -> void:
	#print("jump cut")
	if velocity.y < 0:
		velocity.y = velocity.y / 2



func process_jump_availability() -> void:
	if is_on_floor():
		if allow_jump_variable_resets:
			jump_is_available = true
			player_jumped = false;
			#print("player is on the floor, resetting jump status")
	else:
		if jump_is_available:
			if coyote_timer.is_stopped():
				#print("Started coyote")
				coyote_timer.start()

##box functions
func _unhandled_input(event : InputEvent) -> void:
	if picked_up_box:
		if event.is_action_released("interact_or_throw"):
			interact_released = true
			if charge_time > 0.0:
				
				apply_carrying_sprites(false)
				var jump_vel : Vector2 = Vector2(0, 0)
				if velocity.y < 0:
					jump_vel = Vector2(0, velocity.y) / 3
				var direction : int = sprite.scale.x
				box_ref.throw((Vector2(throw_force_x * direction, 
				throw_force_y) * charge_time) + jump_vel)
				aiming_arc.clear_points()
				
				interact_released = false
				picked_up_box = false
				
				if throw_tween:
					throw_tween.kill()
				throw_tween = self.create_tween()
				
				throw_tween.tween_property(sprite, "rotation_degrees",
				(-max_throw_anim_rot_deg) * direction, 0.1)
				throw_tween.tween_property(sprite, "rotation_degrees", 0, charge_time / 4)
				throw_tween.tween_property(camera, "position:x", 0, 0.1)
				charge_time = 0.0
	
	elif event.is_action_pressed("interact_or_throw"):
		pick_up_nearby_box(false)
	
	elif event.is_action_released("interact_or_throw"):
		reset_recall_animation()
	
	if event.is_action_released("ui_up"):
		jump_cut()
	elif event.is_action_pressed("ui_up"):
		if jump_is_available and not player_jumped:
			jump()


func process_throw(delta : float) -> void:
	if picked_up_box:
		if Input.is_action_pressed("interact_or_throw") and interact_released:
			var direction : int = sprite.scale.x
			charge_time += throw_charge_rate * delta
			charge_time = clampf(charge_time, charge_minimum, 1.0)
			if (aiming_arc_enabled):
				aiming_arc.display_trajectory((Vector2(throw_force_x * direction, throw_force_y)*charge_time), delta)
			sprite.rotation_degrees = lerpf(0.0,
			max_throw_anim_rot_deg * direction, charge_time)
			camera.position.x = lerp(0, 45 * direction, charge_time)
			if Input.is_action_just_pressed("cancel_throw"):
				aiming_arc.clear_points()
				charge_time = 0
				sprite.rotation_degrees = 0
				camera.position.x = 0
				interact_released = false

	#handles box recall feature
	elif Input.is_action_pressed("interact_or_throw"):
		if not available_box:
			jump_is_available = false
			charge_time += throw_charge_rate * delta
			charge_time = clampf(charge_time, 0, 1.8)
			
			if charge_time >= charge_minimum + 0.1:
				is_channeling = true
			
			var charge_animation_modifier : float = charge_time / 9
			animation_target.scale.x = 1.2 - charge_animation_modifier
			animation_target.scale.y = 0.9
			sprite.modulate = Color(1 + charge_time, 1 + charge_time, 1 + charge_time)
			sprite.position.y = 2
			if available_box:
				reset_recall_animation()
				pick_up_nearby_box(false)
			if charge_time >= 1.8: 
				var pos : Vector2 = global_position
				reset_recall_animation()
				var spark : SparkAnimation = spark_animation.instantiate()
				get_parent().add_child(spark)
				spark.start(pos)
				pick_up_nearby_box(true)
		elif charge_time != 0:
			reset_recall_animation()
			pick_up_nearby_box(false)

func reset_recall_animation() -> void:
	is_channeling = false
	charge_time = 0.0
	animation_target.scale = Vector2i(1, 1)
	sprite.position.y = 0
	var tween : Tween = self.create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.2)
	if is_on_floor():
		jump_is_available = true

func apply_carrying_sprites(apply : bool) -> void:
	if apply:
		right_arm.rotation_degrees = -45
		left_arm.rotation_degrees = 30
		left_arm.position.x += 1
		left_arm.position.y -= 1
		box_sprite.texture = available_box.sprite.texture
	else:
		right_arm.rotation_degrees = 0
		left_arm.rotation_degrees = 0
		left_arm.position.x -= 1
		left_arm.position.y += 1
		box_sprite.texture = null


##Movement functions 

func apply_gravity(delta : float) -> void:
	if not is_on_floor():
		if not coyote_timer.is_stopped() and not player_jumped:
			pass
		else:
			if velocity.y < 0:
				velocity.y += default_gravity * delta
			elif velocity.y < max_fall_speed:
				velocity.y += fast_fall_gravity * delta
			# Ensure fall speed past max_fall_speed is consistent
			else:
				velocity.y = max_fall_speed


func process_movement(delta : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction : int = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		if charge_time == 0.0:
			sprite.scale.x = direction
		if is_on_floor() and not is_channeling:
			emit_signal("step_taken")
	
	# Check to make sure player doesn't slide more when running opposite way
	# There may be a better solution
	if ((direction == 1 and velocity.x >= 0) or (direction == -1 and velocity.x <= 0)) and not is_channeling:
		velocity.x = move_toward(velocity.x, direction * speed, (speed * 5) * acceleration * delta)
	else:
		stop_move(delta)

func stop_move(delta : float) -> void:
	velocity.x = move_toward(velocity.x, 0, (speed * 10) * friction * delta)

func teleport_player(pos : Vector2) -> void:
	global_position = pos + Vector2(-8, 0)
	box_ref.global_position = pos + Vector2(+8, 0)

func activate_death_state() -> void:
	set_physics_process(false)
	collision.set_deferred("disabled", true)
	hurtbox_collision.set_deferred("disabled", true)


func addItem(item : Node) -> void:
	print(item)
	emit_signal("new_item", item)
	if item is PermanentHealthPickup:
		for child : Node in get_children():
			if child is HealthComponent:
				child.add_max_health(item.amount_of_plus_health)
	if item is spikeImmunity:
		for child : Node in get_children():
			if child is hurt_box_component:
				child.set_collision_layer_value(8, false)

				
	items.append(item)


func does_player_have_slowing_item() -> bool:
	for item : Node in items:
		if item is Slow_Enemies:
			return true
	return false;



##signal functions

#takes in a redundant Vector2i. maybe separate signal?
func _on_health_death(_pos : Vector2i) -> void:
	#freeze the physics process since the game is finished. If we move movement mechanics out of physics process, consider using the player_died variable
	#set_physics_process(false)
	
	if picked_up_box:
		box_ref.throw(Vector2i(0, 0))
		picked_up_box = false
		interact_released = false
	
	player_died = true;
	
	#signal the death screen to becomme visible
	emit_signal("player_death");

func _on_coyote_timer_timeout() -> void:
	jump_is_available = false;

func _on_box_detector_body_entered(body : CharacterBody2D) -> void:
	if body is PlayerBox:
		available_box = body

func _on_box_detector_body_exited(body : CharacterBody2D) -> void:
	if body is PlayerBox:
		available_box = null

func _on_health_changed(health_change : int) -> void:
	if (!player_died): 
		emit_signal("health_changed", health_change)

func _on_max_health_changed(max_health_change : int) -> void:
	emit_signal("max_health_changed", max_health_change)

func _on_jump_reset_freeze_timer_timeout() -> void:
	allow_jump_variable_resets = true

func _on_settings_menu_aiming_arc_toggled() -> void:
	if (aiming_arc_enabled == true):
		aiming_arc_enabled = false
	else: 
		aiming_arc_enabled = true
	print(aiming_arc_enabled)

func pick_up_nearby_box(summoned : bool) -> void:
	if summoned:
		available_box = box_ref
	if available_box and available_box.is_on_floor():
		picked_up_box = true
		available_box.pick_up(self)
		apply_carrying_sprites(true)
	

