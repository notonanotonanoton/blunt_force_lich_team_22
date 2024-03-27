extends CharacterBody2D

var speed = 30
var dirU = 1
var dirR = 1
var checkone = true
var check2 = false
var count = 0
var player = null
var player_chase = false

var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor() and not is_on_ceiling_only() and not is_on_wall():
		velocity.y += 15
	
	move_and_slide()

	if not is_on_wall():
		if player_chase:
			if (player.position.x - position.x) <= 0:
				print (player.position.x - position.x)
				velocity.x = speed*dirR
				dirR =-1 
			else:
				dirR =1
				print (player.position.x - position.x)
				velocity.x = speed*dirR
		else:
			velocity.x = speed*dirR
	
	if is_on_wall():
		velocity.y = -speed*dirU
	
	
	if is_on_ceiling():
		if player_chase:
			velocity.y += 15
		if checkone:
			dirU=-1
			dirR*=-1
			checkone = false
		velocity.x = speed*dirR

	if is_on_floor():
		if checkone == false:
			dirR*=-1
			dirU=1
			checkone = true
		if is_on_wall():
			velocity.x = speed*dirR+1



func _on_area_2d_body_exited(body):
	player = null
	player_chase = false


func _on_area_2d_body_entered(body):
	player = body
	player_chase = true
