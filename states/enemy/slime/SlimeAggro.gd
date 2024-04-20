extends State

var Player: CharacterBody2D
var direction : float
var movment_Direction : int
@onready var timer : Timer = $Timer
@onready var slime : Slime = $"../.."
var direction_y : float
var idle : bool
var jump_coldown




func enter() -> void:
	Player = get_tree().get_first_node_in_group("Player")
	timer.start(0.5)
	timer.autostart = false
	idle = false
	slime.just_jumped = false
	jump_coldown = false
	
func exit() -> void:
	direction_y = 0
	idle = true
	
func update(_delta: float) -> void:
	direction_y = Player.position.y - slime.position.y
	if (Player.position.x > slime.position.x):
		direction = Player.position.x - slime.position.x

		movment_Direction = 1
	else:
		direction = slime.position.x - Player.position.x
		movment_Direction = -1
	
	slime.velocity.x = slime.speed*movment_Direction
	if (!slime.is_on_floor()):
		slime.velocity.y += slime.gravity*_delta
	
	if (slime.is_on_floor()):
		slime.just_jumped = false
	
	if((slime.is_on_wall() or direction_y < -1) and !slime.just_jumped and slime.is_on_floor() and !jump_coldown):
		slime.velocity.y = -30*slime.speed
		timer.start(2)
		jump_coldown = true
		slime.just_jumped = true
	
	
	
	
	if (direction < -80 or direction > 80):
		slime.velocity.x = 0
		state_transition.emit(self,"SlimeIdle")
	


func physics_update(_delta: float) -> void:
	pass


func _on_timer_timeout():
	jump_coldown = false


