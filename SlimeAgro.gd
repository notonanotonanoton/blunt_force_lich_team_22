extends State
class_name SlimeAgro 

var Player: CharacterBody2D
var direction : float
var movment_Direction : int

@onready var slime = $"../.."
func enter():
	Player = get_tree().get_first_node_in_group("Player")
	
func exit():
	pass
	
func update(_delta: float):
	
	if (Player.position.x > slime.position.x):
		direction = Player.position.x - slime.position.x
		movment_Direction = 1
	else:
		direction = slime.position.x - Player.position.x
		movment_Direction = -1
	
	slime.velocity.x = slime.speed*movment_Direction
	
	if (!slime.is_on_floor()):
		slime.velocity.y += slime.gravity*_delta
	
	if (direction < -50 or direction > 50):
		slime.velocity.x = 0
		state_transition.emit(self,"SlimeIdle")
		
func physics_update(_delta: float):
	pass
