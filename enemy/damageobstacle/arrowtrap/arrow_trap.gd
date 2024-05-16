extends Node2D
class_name spawner

@export var projectile_to_spawn : PackedScene
@export var timer : Timer
@export var time_to_spawn_projectile : int = 4

var South = [89, 91]
var West = [179, 181]
var North = [269, 271]

func _ready():
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = time_to_spawn_projectile
	#print(global_position)
	
	#if you want to implement a custom condition do it here
	timer.start()
	
	print("arrow trap rotation: ", rotation_degrees)
	if rotation_degrees > South[0] and rotation_degrees < South[1]:
		print("facing south")
	if rotation_degrees > West[0] and rotation_degrees < West[1]:
		print("facing West")
	if rotation_degrees > North[0] and rotation_degrees < North[1]:
		print("facing North")


func _on_timer_timeout():
	#print("attempting to spawn arrow")
	var object : Node2D = projectile_to_spawn.instantiate()
	get_parent().add_child.call(object)
	#object.monoDirectional_movement(Vector2(0, -20), global_position+Vector2(-20,0))
	object.add_movement(Vector2(200, 0), global_position+Vector2(10,0))
	timer.start()
	
