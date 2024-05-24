extends Node
class_name HealthComponent

@export_category("Nodes")
@export var generic_animations : GenericAnimations

@export_category("Values")
@export_range(0, 0.5, 0.1) var knockback_stun : float = 0.4
@export_range(0.5, 2, 0.25) var invincibility_time : float = 0.75

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
signal heart_picked_up
signal slowed

func _ready() -> void:
	parent = get_parent()
	
	if not parent is BreakableBlock:
		max_parent_acceleration = parent.acceleration
		stun_timer.connect("timeout", _on_stun_timer_timeout)
		stun_timer.wait_time = knockback_stun
		stun_timer.one_shot = true
		add_child(stun_timer)
		
	
	max_health = health
	
	invincibility_timer.connect("timeout", on_invincibility_timer_timeout)

	invincibility_timer.wait_time = invincibility_time
	invincibility_timer.one_shot = true
	add_child(invincibility_timer)
	
	#For test purposes
	#await get_tree().create_timer(25).timeout
	#set_max_health(8)

#this will currently cause issues with player HUD
func set_health(hp : int) -> void:
	health = hp

func heal(hp : int) -> void:
	#TODO: fix bug with picking up heart when have 2.5 hearts
	health = health+hp
	if(health>max_health):
		health = max_health
	emit_signal("heart_picked_up")  
	
func get_health() -> int:
	return health

func get_max_health() -> int:
	return max_health
	
func add_max_health(health_to_be_added : int) -> void:
	
		max_health += health_to_be_added
		heal(health_to_be_added)
		emit_signal("max_health_changed", max_health)

func set_max_health(new_max_health : int) -> void:
	
	if new_max_health>=max_health:
		max_health = new_max_health
		heal(new_max_health-max_health)
	
	else:
		if health<new_max_health:
			max_health = new_max_health
			set_health(new_max_health)
	

	emit_signal("max_health_changed", new_max_health)

func take_damage(damage : int, enemy_position : Vector2, enemy_hurtbox : hurt_box_component, should_slow : bool) -> void:
	player_left_hitbox = false;
	latest_enemy_hit_pos = enemy_position
	print("invincibility timer is_stopped : ", invincibility_timer.is_stopped())
	if invincibility_timer.is_stopped() == true:
		health -= damage
		
		if not parent is BreakableBlock:
			var knockback : int = knockback_strength
			if parent is PlayerCharacter:
				knockback *= 2
				for item : Node in parent.items:
					if item is ThornsItem:
						if enemy_hurtbox != null:
							enemy_hurtbox.damage(item.thornsDamage, parent.global_position, false)
				
				emit_signal("health_changed", damage)
			else:
				parent.damage_aggro_range_increase()
	
			#saves direction
			if(enemy_position.direction_to(parent.global_position).x < 0):
				knockback *= -1
			
			if should_slow:
				emit_signal("slowed")
			
			
			parent.velocity = Vector2i(knockback, knockback_up_strength)
	
			parent.acceleration = 0
			stun_timer.start()
			
		invincibility_timer.start()
		
		if health > 0:
			emit_signal("damage_taken")
		
		else:
			parent.activate_death_state()
			#queue_free handled in genericanimations
			emit_signal("death", parent.global_position)

func _on_stun_timer_timeout() -> void:
	parent.acceleration = max_parent_acceleration

		
func on_invincibility_timer_timeout() -> void:
	if(player_left_hitbox == false and get_parent() is PlayerCharacter):
		take_damage(1, latest_enemy_hit_pos, null, false)

func update_player_left_hitbox() -> void:
	player_left_hitbox = true
	


func _on_player_character_new_item(new_item):
	if new_item is InvincibilityExtender:
		print("previous invincibility time: ", invincibility_time)
		invincibility_time += new_item.extensionDuration
		invincibility_timer.wait_time = invincibility_time
		print("new invincibility time: ", invincibility_time)

