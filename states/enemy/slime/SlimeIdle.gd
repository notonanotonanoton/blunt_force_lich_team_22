extends State

@onready var timer : Timer = $Timer
@onready var slime : Slime = $"../.."
@onready var sprite2d : Sprite2D = $"../../Sprite2D"
var direction : float
var Player: CharacterBody2D
var wander_time : float
var move_time : float
var Jump_Direction_Vertical : int
var Jump_Direction_Horizontal : float
var jump_time : float
var just_jumped : bool
var agro : bool


func random():
	if(randf_range(-1,1)> 0):
		Jump_Direction_Horizontal = 1
	else:
		Jump_Direction_Horizontal = -1
	wander_time = randf_range(1,4)

func moveTime():
	move_time = 2

func enter():
	agro = false
	just_jumped = false
	random()
	timer.start(5)
	Player = get_tree().get_first_node_in_group("Player")
	jump_time = randf_range(1,2)

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
	
	#Checks WanderTime and resets it when it is completed
	if (wander_time > 0):
		wander_time -= _delta
		if (move_time > 0):
			move_time -= _delta
		else :
			slime.velocity.x = 0
	elif (jump_time > 0):
		#slime.velocity.x = slime.speed*Jump_Direction_Horizontal
		moveTime()
		random()
	
	
	#Basic gravity
	if(!slime.is_on_floor() or !slime.is_on_ceiling()):
		slime.velocity.y += slime.gravity*_delta*Jump_Direction_Vertical
	
		if((slime.is_on_floor() or slime.is_on_ceiling())and just_jumped):
			slime.velocity.x = 0


	
	#Is the trigger for aggro on player
	if (direction < 30):
		print("ANGY")
		state_transition.emit(self,"SlimeAgro")
	
	
	
	
	
	#Is the trigger for jump
func _on_timer_timeout():
	if(!agro):
		if(randi_range(1,5) != 2):
			slime.velocity.y = -randi_range(20,40) * Jump_Direction_Vertical*slime.speed
			slime.velocity.x = slime.speed*Jump_Direction_Horizontal*randi_range(10,20)
			just_jumped = true
			timer.start(2)
		else:
			slime.velocity.y = -randi_range(500,600) * Jump_Direction_Vertical
