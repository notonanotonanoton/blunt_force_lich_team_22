extends CharacterBody2D
class_name PlayerBox

@export_category("Nodes")
@export var arming_timer : Timer
@export var sprite : Sprite2D
@export var collision_shape : CollisionShape2D
@export var hitbox : hit_box_component

@export_category("Values")
@export_range(0, 1, 0.1) var friction : float = 0.8
@export_range(0, 1, 0.05) var minimum_arming_time : float = 0.05
@export_range(0, 300, 1) var minimum_damage_speed : int = 80
@export_range(0, 300, 10) var hit_bounce_strength : int = 150

var default_gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var holder : PlayerCharacter
#needed for healthmodule implementation
var can_deal_damage : bool = false

func _ready() -> void:
	arming_timer.wait_time = minimum_arming_time

func _physics_process(delta : float) -> void:
	if arming_timer.is_stopped() and abs(velocity.x) > minimum_damage_speed:
		sprite.modulate = Color(1.8, 1.8, 2.0)
		can_deal_damage = true
	else:
		sprite.modulate = Color(1, 1, 1)
		can_deal_damage = false
	
	if holder:
		global_position = holder.global_position
		#global_position.y = holder.global_position.y
		
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
		show_box()
		holder = null
		arming_timer.start()
		velocity = throw_force

func hide_box() -> void:
	collision_shape.set_deferred("disabled", true)
	hitbox.set_deferred("disabled", true)
	visible = false

func show_box() -> void:
	collision_shape.set_deferred("disabled", false)
	hitbox.set_deferred("disabled", false)
	visible = true


func _on_hit_box_component_dealt_damage(target_global_position : Vector2) -> void:
	var knockback : int = hit_bounce_strength
	if target_global_position.direction_to(global_position).x < 0:
		knockback *= -1
	
	velocity = Vector2i(knockback, (knockback + 1) / 2)
	
