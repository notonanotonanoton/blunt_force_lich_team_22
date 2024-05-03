extends Node
class_name HealthComponent

@export_category("Nodes")
@export var generic_animations : GenericAnimations

@export_category("Values")
@export_range(0, 0.5, 0.1) var knockback_stun : float = 0.3
@export_range(0, 200, 10) var knockback_strength : int = 100
@export_range(-200, 0, 10) var knockback_up_strength : int = -60
@export_range(1, 50, 1) var health : int = 3

var max_health : int = health

# big characters should have a smaller modifier

var timer : Timer = Timer.new()
var parent : CharacterBody2D
var max_parent_acceleration : float

signal death
signal health_changed
signal max_health_changed
signal damage_taken

func _ready() -> void:
	parent = get_parent()
	
	max_health = health
	max_parent_acceleration = parent.acceleration
	
	
	timer.connect("timeout", _on_timer_timeout)

	timer.wait_time = knockback_stun
	timer.one_shot = true
	add_child(timer)

#this will currently cause issues with player HUD
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
		if(health<=0):
			#queue_free handled in genericanimations
			emit_signal("death", parent.global_position)
		else:
			emit_signal("health_changed") #testa ha den där 
			emit_signal("damage_taken")
	
func _on_timer_timeout() -> void:
	parent.acceleration = max_parent_acceleration


