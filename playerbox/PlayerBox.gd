extends CharacterBody2D

var held : bool
var first_sender : CharacterBody2D
var collision_shape : CollisionShape2D
@export_range(0, 1, 0.1) var friction : float = 0.5
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var arming_timer : Timer
@export var minimum_arming_time : float = 0.15

#this will only check so that the box is moving at all. 
#Assuming you want to have a specific minimum traveling air speed then you will need to measure the desired amount and input it.
#The current general travel-speed is ~~200
@export var minimum_speed : int = 1

func _ready() -> void:
	collision_shape = get_node("CollisionShape2D") as CollisionShape2D
	arming_timer.one_shot = true
	arming_timer.wait_time = minimum_arming_time

func can_deal_damage() -> bool:
	#print("check if timer is stopped: ", arming_timer.is_stopped())
	if arming_timer.is_stopped():
		#print("checking minimum velocity: ", minimum_speed)
		#print("checking current velocity: ", velocity.x)
		if velocity.x>minimum_speed:
			return true
	return false

func _physics_process(delta : float) -> void:
	move_and_slide()
	#print(held)
	if held:
		position.x = first_sender.position.x
		position.y = first_sender.position.y - 15
		
	elif !is_on_floor():
		velocity.y += default_gravity * delta
		
	if is_on_floor():
		if (velocity.x > 0 || velocity.x < 0):
			velocity.x = (velocity.x) * friction * delta
		
func picked_up_by(sender : CharacterBody2D) -> void:
	if first_sender == null:
		first_sender = sender
		set_deferred("freeze", true)
		held = true
		disable_collision()

func thrown_by(sender : CharacterBody2D, charge_time : float) -> void:
	
	arming_timer.start()
	
	if (charge_time > 1):
		charge_time = 1
	
	var charge_factor : float = 1 + charge_time
	
	if held:
		#reactivates physics and allows the box to be picked up again
		held = false
		enable_collision()
		first_sender = null
		set_deferred("freeze", false)
		
		
		#decides where the box will be thrown
		if sender.looking_direction == 1:
			velocity = Vector2(200, -50) * charge_factor
		else:
			velocity = Vector2(-200, -50) * charge_factor
	
func disable_collision()-> void:
	collision_shape.set_deferred("disabled", true)

func enable_collision() -> void:
	collision_shape.set_deferred("disabled", false)
	
""" set velocity instead for characterbody2d
func send_right() -> void:
	apply_central_impulse(Vector2(500, -500))

func send_left() -> void:
	apply_central_impulse(Vector2(-500, -500))
"""
