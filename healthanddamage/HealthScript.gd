extends Node
class_name HealthComponent

@export_category("Nodes")
@export var generic_animations : GenericAnimations

@export_category("Values")
@export_range(0, 0.5, 0.1) var knockback_stun : float = 0.3
@export var invincibility_time : float = 0.75

@export_range(0, 200, 10) var knockback_strength : int = 100
@export_range(-200, 0, 10) var knockback_up_strength : int = -60
@export_range(1, 50, 1) var health : int = 3

var max_health : int = health

# big characters should have a smaller modifier

var stun_timer : Timer = Timer.new()
var invincibility_timer : Timer = Timer.new()
var parent : CharacterBody2D
var max_parent_acceleration : float
var player_left_hitbox : bool = true
var latest_enemy_hit_pos : Vector2

signal death
signal health_changed
signal max_health_changed
signal damage_taken

func _ready() -> void:
	parent = get_parent()
	
	max_health = health
	max_parent_acceleration = parent.acceleration
	
	
	stun_timer.connect("timeout", _on_stun_timer_timeout)

	stun_timer.wait_time = knockback_stun
	stun_timer.one_shot = true
	add_child(stun_timer)
	
	invincibility_timer.connect("timeout", on_invincibility_timer_timeout)

	invincibility_timer.wait_time = invincibility_time
	invincibility_timer.one_shot = true
	add_child(invincibility_timer)
	
	#For test purposes
	await get_tree().create_timer(25).timeout
	set_max_health(8)

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
	
func set_max_health(new_max_health : int) -> void:
	if (new_max_health < max_health):
		health -= 2
	else:
		health += 2
	max_health = new_max_health
	emit_signal("max_health_changed", new_max_health)

func take_damage(damage : int, enemy_position : Vector2) -> void:
	player_left_hitbox = false;
	latest_enemy_hit_pos = enemy_position
	if invincibility_timer.is_stopped() == true:
		health -= damage
		
		var knockback : int = knockback_strength
		if parent is PlayerCharacter:
			knockback *= 2
		
		#saves direction
		if(enemy_position.direction_to(parent.global_position).x < 0):
			knockback *= -1
		
		parent.velocity = Vector2i(knockback, knockback_up_strength)
		
		parent.acceleration = 0
		stun_timer.start()
		invincibility_timer.start()
		emit_signal("health_changed", damage)  
		emit_signal("damage_taken")
		if(health<=0):
			#queue_free handled in genericanimations
			emit_signal("death", parent.global_position)
	
func _on_stun_timer_timeout() -> void:
	parent.acceleration = max_parent_acceleration

		
func on_invincibility_timer_timeout() -> void:
	if(player_left_hitbox == false):
		take_damage(1, latest_enemy_hit_pos)

func update_player_left_hitbox() -> void:
	player_left_hitbox = true
	
