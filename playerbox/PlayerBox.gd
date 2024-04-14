extends CharacterBody2D

var held : bool
var first_sender : CharacterBody2D
var collision_shape : CollisionShape2D
@export_range(0, 1, 0.1) var friction : float = 0.5
var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape = get_node("CollisionShape2D") as CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func thrown_by(sender : CharacterBody2D) -> void:
	if held:
		print("throw box")
		held = false
		enable_collision()
		first_sender = null
		set_deferred("freeze", false)
		if sender.looking_direction == 1:
			velocity = Vector2(250, -150)
		else:
			velocity = Vector2(-250, -150)
	
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
