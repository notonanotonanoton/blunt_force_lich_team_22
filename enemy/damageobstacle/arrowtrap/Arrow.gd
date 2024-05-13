extends Area2D
class_name Arrow

@export var ground_collider : CollisionShape2D
@export var gravity_timer : Timer

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var can_deal_damage : bool = true

var movement : Vector2 = Vector2.ZERO

func _ready() -> void:
	#change wait time in GravityTimer node if desired.
	#beware it affects all entities that use Arrow, such as arrow trap and skeleton archer
	gravity_timer.start()

func _physics_process(delta : float) -> void:
	position += movement * delta
	if has_overlapping_bodies():
		queue_free()
	if gravity_timer.is_stopped():
		position.y -= default_gravity

func add_movement(mov : Vector2, pos : Vector2, rot : Vector2) -> void:
	movement = mov
	global_position = pos
	rotation = rot.angle()
