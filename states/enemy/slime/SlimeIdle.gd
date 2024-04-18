extends State

@onready var timer : Timer = $Timer
@onready var slime : Slime = $"../.."
@onready var sprite2d : Sprite2D = $"../../Sprite2D"
var direction : float
var Player: CharacterBody2D
var Jump_Direction_Vertical : int
var Jump_Direction_Horizontal : float
var jump_time : float
var just_jumped : bool
var agro : bool
var moving_time : bool
var just_once : bool
var wall : bool


func random():
	if(randf_range(-1,1)> 0):
		Jump_Direction_Horizontal = 1
	else:
		Jump_Direction_Horizontal = -1
	jump_time = randf_range(1,4)


func enter():
	moving_time = true
	agro = false
	just_jumped = false
	random()
	timer.start(3)
	Player = get_tree().get_first_node_in_group("Player")
	jump_time = randf_range(1,4)

func exit():
	pass

func update(_delta: float):
	if(slime.is_on_ceiling()):
		Jump_Direction_Vertical = -1
	else :
		Jump_Direction_Vertical = 1
	
	#Checks Player
	if (Player.position.x > slime.position.x):
		direction = Player.position.x - slime.position.x
	else:
		direction = slime.position.x - Player.position.x
	
	#Basic gravity
	if(!slime.is_on_floor() or !slime.is_on_ceiling()):
		slime.velocity.y += slime.gravity*_delta*Jump_Direction_Vertical
	
		if((slime.is_on_floor() or slime.is_on_ceiling())and just_jumped):
			slime.velocity.x = 0
			just_jumped = false
			moving_time = true
	
	#Is the trigger for aggro on player
	if (direction < 20 and slime.is_on_ceiling()):
		state_transition.emit(self,"SlimeAgro")
		agro = true
	elif (direction < 80 and !slime.is_on_ceiling()):
		state_transition.emit(self,"SlimeAgro")
		agro = true
	
	#Responsible for movment of the slime
	if(moving_time):
		if(just_once):
			timer.start(4)
			just_once = false
		slime.velocity.x = slime.speed*Jump_Direction_Horizontal
		if(slime.is_on_wall()):
			if(!wall):
				Jump_Direction_Horizontal *= -1
				wall = true
		elif (!slime.is_on_wall()):
			wall = false
			
	
	#Makes sure the slime stands still while jumping
	if(!moving_time):
		if(just_once and slime.is_on_floor() or slime.is_on_ceiling()):
			slime.velocity.x = 0
			just_once = false

	
	#Is the trigger for jump
func _on_timer_timeout():
	if(!agro and !just_jumped and !moving_time):
		moving_time = false
		just_once = true
		slime.velocity.x = 0
		if(jump_time <= 3):
			var temp : int = randi_range(20,40)
			slime.velocity.y = -temp * Jump_Direction_Vertical*slime.speed
			slime.velocity.x = slime.speed*Jump_Direction_Horizontal*temp
			just_jumped = true
			timer.start(jump_time)
		else:
			slime.velocity.y = -randi_range(500,600) * Jump_Direction_Vertical
			timer.start(jump_time)
			just_jumped = true
	elif (moving_time):
		moving_time = false
		just_once = true
		


