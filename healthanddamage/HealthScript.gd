extends Node
class_name HealthComponent

@export var health : int = 3
@export var knockback_stun : float = 0.4

# big characters should have a smaller modifier
@export var knockback_modifier : int = 200
var timer : Timer = Timer.new()
var max_health : int
var max_parent_acceleration : float

signal death_signal
signal taken_damage

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

func take_damage(damage : int, enemy_position : Vector2) -> void:
	
	if timer.is_stopped() == true:
		health -= damage
		
	
		var knockback_direction : Vector2 = enemy_position.direction_to(get_parent().global_position)
		#make sure we give some airtime
		var knockback_strength : int = damage*knockback_modifier
		var knockback : Vector2 = knockback_direction*knockback_strength
		
		
		get_parent().velocity =knockback+Vector2(0, -30)
		
		get_parent().acceleration = 0
		timer.start()
		
		if(health<=0):
			health = 0
			emit_signal("death_signal")
			get_parent().queue_free()
		else:
			emit_signal("taken_damage")
	
func _on_timer_timeout() -> void:
	get_parent().acceleration = max_parent_acceleration
