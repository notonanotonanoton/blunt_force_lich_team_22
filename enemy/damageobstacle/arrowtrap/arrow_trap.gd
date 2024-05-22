extends Node2D
class_name spawner

@export_category("Nodes")
@export var projectile_to_spawn : PackedScene
@export var timer : Timer
@export var sprite : Sprite2D

@export_category("Values")
@export var time_to_spawn_projectile : int = 4
@export var arrow_Speed : int = 200
@export_range(-1, 1, 2) var horizontal_direction = 1

var South = [89, 91] #
var West = [179, 181]
var North = [269, 271]
var East = [-1, 1]
#google bitwise operations
var RotationDirection = 0


func _ready():
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = time_to_spawn_projectile
	sprite.scale.x = horizontal_direction



	print("arrow trap rotation: ", rotation_degrees)
	if rotation_degrees > South[0] and rotation_degrees < South[1]:
		RotationDirection = 1 << 0
	elif (rotation_degrees > West[0] and rotation_degrees < West[1]) or (
		horizontal_direction == -1 and !abs(rotation_degrees) > 0):
		RotationDirection = 1 << 1
	elif rotation_degrees > North[0] and rotation_degrees < North[1]:
		RotationDirection = 1 << 2
	elif rotation_degrees > East[0] and rotation_degrees < East[1]:
		RotationDirection = 1 << 3
	else:
		#since we are handling rotation and arrow spawning manually per "direction" its next to impossible to handle every direction. 
		#Thus we throw this error if the arrow trap does not fall within an acceptable range of that cardinal direction.
		assert(false, "ARROW TRAP IS INCORRECTLY ROTATED, PLEASE ONLY ROTATE IN 90 DEGREE INCREMENTS. Arrows can only spawn in cardinal directions")
	
	#no need to keep them in memory anymore
	South = null
	West = null
	North = null
	East = null
	
	timer.start()


func _on_timer_timeout():

	var object : Node2D = projectile_to_spawn.instantiate()
	get_parent().add_child.call(object)



	
	if RotationDirection & (1<<1):
		print("facing west")
		object.add_movement(Vector2(-arrow_Speed, 0), global_position+Vector2(-10,0))
	elif RotationDirection & (1<<3):
		object.add_movement(Vector2(arrow_Speed, 0), global_position+Vector2(10,0))
		print("facing east")
	elif RotationDirection & (1<<2):
		object.add_movement(Vector2(0, -arrow_Speed), global_position+Vector2(0,-10))
		print("facing north")
	elif RotationDirection & (1<<0):
		object.add_movement(Vector2(0, arrow_Speed), global_position+Vector2(0,10))
		print("facing south")



		
	timer.start()
	
