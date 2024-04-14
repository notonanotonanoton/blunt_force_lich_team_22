extends Node
class_name HealthComponent

@export var health : int = 3
@export var knockback_stun : float = 0.3

# big characters should have a smaller modifier
@export var knockback_modifier : int = 500
var timer : Timer = Timer.new()
var max_health : int
var max_parent_acceleration : float

signal death_signal

func _ready() -> void:
	max_health = health
	max_parent_acceleration = get_parent().acceleration
	
	
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

func take_damage(damage, enemy_position : Vector2) -> void:
	
	for child in get_parent().get_children():
		if child.is_class("state_machine"):
			child.change_state(child.current_state, "PlayerTakingDamage")
	
	if timer.is_stopped() == true:
		health = health-damage
		
	
		var knockback_direction = enemy_position.direction_to(get_parent().global_position)
		#make sure we give some airtime
		var knockback_strength = damage*knockback_modifier
		var knockback = knockback_direction*knockback_strength
		
		
		get_parent().velocity =knockback+Vector2(0, -30)
		
		get_parent().acceleration = 0
		timer.start()
		
		if(health<=0):
			health = 0
			emit_signal("death_signal")
			#get_parent().queue_free()
	
func _on_timer_timeout() -> void:
	get_parent().acceleration = max_parent_acceleration
