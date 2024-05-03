extends Node2D
class_name spawner

@export var projectile_to_spawn : PackedScene
@export var timer : Timer
@export var time_to_spawn_projectile : int = 4

func _ready():
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = time_to_spawn_projectile
	
	#if you want to implement a custom condition do it here
	timer.start()




func _on_timer_timeout():
	
	var object : Node2D = projectile_to_spawn.instantiate()
	get_parent().add_child.call_deferred(object)
	object.position = global_position
	timer.start()
	
