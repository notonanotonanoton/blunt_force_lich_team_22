extends State

@onready var slime : Slime = $"../.."
var direction : float
var Player: CharacterBody2D
var wander_time : float
var move_time : float
var move_direction : float
var jump_time : float
func random():
	if(randf_range(-1,1)> 0):
		move_direction = 1
	else:
		move_direction = -1
	wander_time = randf_range(1,4)

func moveTime():
	move_time = 2

func enter():
	random()
	Player = get_tree().get_first_node_in_group("Player")
	jump_time = randf_range(5,10)

func exit():
	pass

func update(_delta: float):
	
	#Checks Player
	if (Player.position.x > slime.position.x):
		direction = Player.position.x - slime.position.x
	else:
		direction = slime.position.x - Player.position.x
	
	#Checks WanderTime and resets it when it is completed
	if (wander_time > 0):
		wander_time -= _delta
		if (move_time > 0):
			move_time -= _delta
		else :
			slime.velocity.x = 0
	else:
		slime.velocity.x = slime.speed*move_direction
		moveTime()
		random()
	
	#Basic gravity
	if(!slime.is_on_floor()):
		if(slime.is_on_ceiling()):
			slime.velocity.y= 0
		else:
			slime.velocity.y += slime.gravity*_delta
	
	#Is the trigger for aggro on player
	if (direction < 30):
		state_transition.emit(self,"SlimeAgro")
	
	#Is the trigger for jump
	if (jump_time > 0):
		jump_time -= _delta
	else :
		state_transition.emit(self,"SlimeJump")
	
	
