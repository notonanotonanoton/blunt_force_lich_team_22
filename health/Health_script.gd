extends Node
var health : int
var max_health : int
signal death_signal

func set_health(hp):
	if max_health == null:
		max_health = hp
	health = hp

func heal(hp):
	health = health+hp
	if(health>max_health):
		health = max_health

func get_health():
	return health

func get_max_health():
	return max_health

func take_damage(damage):
	health = health-damage
	if(health<0):
		health = 0
		emit_signal("death_signal")
	
