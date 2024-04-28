extends CharacterBody2D
class_name PlayerBox

@export_category("Nodes")
@export var arming_timer : Timer
@export var sprite : Sprite2D
@export var collision_shape : CollisionShape2D
@export var hitbox : hit_box_component

@export_category("Values")
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1, 0.05) var minimum_arming_time : float = 0.1
@export_range(0, 300, 1) var minimum_damage_speed : int = 80

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var holder : PlayerCharacter
#needed for healthmodule implementation
var can_deal_damage : bool = false

func _ready() -> void:
	arming_timer.wait_time = minimum_arming_time

func _physics_process(delta : float) -> void:
	if arming_timer.is_stopped() and abs(velocity.x) > minimum_damage_speed:
		sprite.modulate = Color(1.5, 1.5, 1.5)
		can_deal_damage = true
	else:
		sprite.modulate = Color(1, 1, 1)
		can_deal_damage = false
	
	if holder:
		position.x = holder.position.x
		position.y = holder.position.y - 6
		
	elif !is_on_floor():
		velocity.y += default_gravity * delta
		
	if is_on_floor():
		if velocity.x > 0 or velocity.x < 0:
			velocity.x -= (velocity.x * 10) * (friction * delta)
	
	move_and_slide()

func pick_up(sender : PlayerCharacter) -> void:
	if holder == null:
		holder = sender
		hide_box()

func throw(throw_force : Vector2i) -> void:
	if holder:
		var jump_offset : = Vector2i(0, 0)
		var holder_velocity : int = abs(holder.velocity.y)
		if holder_velocity >= 1:
			jump_offset = Vector2i(0, holder_velocity / 2)
		show_box()
		holder = null
		arming_timer.start()
		velocity = throw_force + jump_offset

func hide_box() -> void:
	collision_shape.set_deferred("disabled", true)
	hitbox.set_deferred("disabled", true)
	visible = false

func show_box() -> void:
	collision_shape.set_deferred("disabled", false)
	hitbox.set_deferred("disabled", false)
	visible = true
