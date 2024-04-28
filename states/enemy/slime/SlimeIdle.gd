extends State

@onready var timer : Timer = $Timer
@onready var slime : Slime = $"../.."
@onready var sprite2d : Sprite2D = $"../../Sprite2D"
@onready var animation : AnimationPlayer = $"../../AnimationPlayer"
var direction : float
var Player: CharacterBody2D
var Jump_Direction_Vertical : int
var Jump_Direction_Horizontal : float
var jump_time : float
var agro : bool
var moving_time : bool
var just_once : bool
var wall : bool
var slime_speed_realisify : float


func random():
	if(randi_range(-1,1)> 0):
		Jump_Direction_Horizontal = 1
		if(slime.is_on_ceiling()):
			animation.play("Look_Left")
		elif(slime.is_on_floor()):
			animation.play("Look_Right")
	else:
		Jump_Direction_Horizontal = -1
		if(slime.is_on_ceiling()):
			animation.play("Look_Right")
		elif(slime.is_on_floor()):
			animation.play("Look_Left")
	jump_time = randi_range(1,4)


func enter():
	random()
	animation.play("reset")
	moving_time = true
	agro = false
	slime.just_jumped = false
	timer.start(3)
	Player = get_tree().get_first_node_in_group("Player")
	jump_time = randi_range(1,4)

func exit():
	agro = true

func update(_delta: float):
	if(slime.is_on_ceiling() and !agro):
		if(Jump_Direction_Vertical == 1):
			animation.play("On_Ceiling")
		Jump_Direction_Vertical = -1
	else :
		if(Jump_Direction_Vertical == -1 and !agro):
			animation.play("reset")
		Jump_Direction_Vertical = 1

	
	#Checks Player
	if (Player != null and Player.position.x > slime.position.x):
		direction = Player.position.x - slime.position.x
	elif(Player != null):
		direction = slime.position.x - Player.position.x
	#Basic gravity
	if(!slime.is_on_floor() or !slime.is_on_ceiling()):
		slime.velocity.y += slime.gravity*_delta*Jump_Direction_Vertical
	
		if((slime.is_on_floor() or slime.is_on_ceiling())and slime.just_jumped):
			slime.velocity.x = 0
			slime.just_jumped = false
			moving_time = true
	
	#Is the trigger for aggro on player
	if (direction < 20 and slime.is_on_ceiling()):
		animation.play("reset")
		state_transition.emit(self,"SlimeAgro")

	elif (direction < 80 and !slime.is_on_ceiling()):
		animation.play("reset")
		state_transition.emit(self,"SlimeAgro")
	
	#Responsible for movment of the slime
	if(moving_time):
		if(just_once):
			timer.start(4)
			just_once = false
			slime_speed_realisify = 1.25
		if(timer.time_left > 3):
			slime_speed_realisify = 1
		elif (timer.time_left > 2):
			slime_speed_realisify = 0.75
		elif (timer.time_left > 1):
			slime_speed_realisify = 0.5
		else :
			slime_speed_realisify = 0
		
		slime.velocity.x = slime.speed*Jump_Direction_Horizontal*slime_speed_realisify
		if(slime.is_on_wall()):
			if(!wall):
				if(Jump_Direction_Horizontal == -1):
					animation.play("Look_Right")
				else: 
					animation.play("Look_Left")
				Jump_Direction_Horizontal *= -1
				wall = true
		elif (!slime.is_on_wall()):
			wall = false
			
	
	#Makes sure the slime stands still while jumping
	if(!moving_time):
		if(just_once and slime.is_on_floor() or slime.is_on_ceiling()):
			if(jump_time >= 3):
				animation.play("High_Jump")
			elif(jump_time < 3):
				animation.play("Normal_Jump")
			slime.velocity.x = 0
			just_once = false

	
	#Is the trigger for jump
func _on_timer_timeout():
	if(!agro and !slime.just_jumped and !moving_time):
		animation.play("reset")
		moving_time = false
		just_once = true
		slime.velocity.x = 0
		if(jump_time < 3):
			var temp : int = randi_range(20,40)
			slime.velocity.y = -temp * Jump_Direction_Vertical*slime.speed
			slime.velocity.x = slime.speed*Jump_Direction_Horizontal*temp
			slime.just_jumped = true
			timer.start(jump_time)
			random()
		else:
			slime.velocity.y = -randi_range(500,600) * Jump_Direction_Vertical*(jump_time/2)
			timer.start(jump_time)
			slime.just_jumped = true
			random()
	elif (moving_time and !slime.is_on_ceiling()):
		moving_time = false
		just_once = true
	else :
		just_once = true
		


