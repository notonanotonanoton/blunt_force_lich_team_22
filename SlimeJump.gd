extends State
class_name SlimeJump #class_name names the class you extended from whatever class. Basically names the class your script represents. 

@onready var slime = $"../.."
var Jump_height : float
var Charge_time : float
var Jump_Direction : int
func enter():
	if(slime.is_on_ceiling()):
		Jump_Direction = 1
	else :
		Jump_Direction = -1
	Jump_height = randf_range(10,80)
	Charge_time = 3
	slime.velocity.x = 0
	pass
	
	
func exit():
	pass
	
func update(_delta: float):
	if(Charge_time > 0):
		Charge_time -= _delta
	else:
		slime.velocity.y = slime.speed*Jump_height*Jump_Direction
		slime.velocity.x = slime.speed*Jump_Direction*Jump_height*0.50
		if (slime.is_on_ceiling() or slime.is_on_floor()):
			slime.velocity.x = 0
			state_transition.emit(self, "SlimeIdle")
		


