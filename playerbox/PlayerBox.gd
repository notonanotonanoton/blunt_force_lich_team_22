extends RigidBody2D

var held : bool
var first_sender : CharacterBody2D
var collision_shape : CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape = get_node("CollisionPolygon2D") as CollisionPolygon2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float) -> void:
	if held:
		self.global_transform.origin = ((first_sender.global_position)-Vector2(0, 20))


func picked_up_by(sender : CharacterBody2D) -> void:
	if first_sender == null:
		first_sender = sender
		set_deferred("freeze", true)
		held = true
		disable_collision()


func thrown_by(sender : CharacterBody2D) -> void:
	if held:
		held = false;
		enable_collision()
		first_sender = null;
		set_deferred("freeze", false)
		if sender.looking_direction == 1:
			send_right.call_deferred()
		else:
			send_left.call_deferred()
	
	
func disable_collision()-> void:
	collision_shape.set_deferred("disabled", true)

func enable_collision() -> void:
	collision_shape.set_deferred("disabled", false)

func send_right() -> void:
	apply_central_impulse(Vector2(500, -500))

func send_left() -> void:
	apply_central_impulse(Vector2(-500, -500))
