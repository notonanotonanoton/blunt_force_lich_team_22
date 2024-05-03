extends Node
class_name HealthComponent

@export_category("Nodes")
@export var generic_animations : GenericAnimations

@export_category("Values")
@export_range(0, 0.5, 0.1) var knockback_stun : float = 0.3
@export_range(0, 200, 10) var knockback_strength : int = 100
@export_range(-200, 0, 10) var knockback_up_strength : int = -60
@export_range(1, 50, 1) var health : int = 3

# big characters should have a smaller modifier

var timer : Timer = Timer.new()
var max_health : int
var parent : CharacterBody2D
var max_parent_acceleration : float

signal death_signal
signal damage_taken

func _ready() -> void:
	parent = get_parent()
	max_health = health
	max_parent_acceleration = parent.acceleration
	
	
	timer.connect("timeout", _on_timer_timeout)

	timer.wait_time = knockback_stun
	timer.one_shot = true
	add_child(timer)

func set_health(hp : int) -> void:
	health = hp

func heal(hp : int) -> void:
	health = health+hp
	if(health>max_health):
		health = max_health

func get_health() -> int:
	return health

func get_max_health() -> int:
	return max_health

func take_damage(damage : int, enemy_position : Vector2) -> void:
	
	if timer.is_stopped() == true:
		health -= damage
		
		var knockback : int = knockback_strength
		if parent is PlayerCharacter:
			knockback *= 2
		
		#saves direction
		if(enemy_position.direction_to(parent.global_position).x < 0):
			knockback *= -1
		
		parent.velocity = Vector2i(knockback, knockback_up_strength)
		
		parent.acceleration = 0
		timer.start()
		emit_signal("damage_taken")
		if(health<=0):
			health = 0
			if(get_parent() is PlayerCharacter):
				emit_signal("death_signal")
			else:
				get_parent().queue_free()
	
func _on_timer_timeout() -> void:
	parent.acceleration = max_parent_acceleration


