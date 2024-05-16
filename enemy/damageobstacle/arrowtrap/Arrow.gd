extends Area2D
class_name Arrow

@export var ground_collider : CollisionShape2D
@export var gravity_timer : Timer

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity") / 6
var can_deal_damage : bool = true

var movement : Vector2 = Vector2.ZERO

func _ready() -> void:
	#change wait time in GravityTimer node if desired.
	#beware it affects all entities that use Arrow, such as arrow trap and skeleton archer
	gravity_timer.start() 
	#print("created arrow")

func _physics_process(delta : float) -> void:	
	global_position += movement * delta

	if has_overlapping_bodies():
		queue_free()

	if gravity_timer.is_stopped():
		movement.y += default_gravity*delta
	rotation = global_position.direction_to(self.global_position+(movement*100)-Vector2(0, 0)).angle()
	
func add_movement(mov : Vector2, pos : Vector2) -> void:
	movement = mov
	global_position = pos
