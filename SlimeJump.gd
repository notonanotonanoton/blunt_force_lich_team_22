extends State
class_name SlimeJump #class_name names the class you extended from whatever class. Basically names the class your script represents. 

@onready var slime = $"../.."
var Jump_height : float
var Charge_time : float
var Jump_Direction_Vertical : int
var Jump_Direction_Horizontal : int
var Jump_Time
var Long_Jump : bool
func enter():
	if(slime.is_on_ceiling()):
		Jump_Direction_Vertical = 1
	else :
		Jump_Direction_Vertical = -1
	Charge_time = randf_range(1,2)
	if(Charge_time > 1.5 and slime.is_on_floor):
		Charge_time = 1
		Long_Jump = true;
		Jump_Time = 1
		Jump_height = randf_range(20,30)
		if(randf_range(1,2) < 1.5):
			Jump_Direction_Horizontal = -1
		else :
			Jump_Direction_Horizontal = 1
	else :
		Jump_height = randf_range(10,80)
		Charge_time = 3
		Jump_Time = 1
		Long_Jump = false;
	slime.velocity.x = 0
	
	
func exit():
	slime.velocity.x = 0
	
func update(_delta: float):
	
	if(Charge_time > 0):
		Charge_time -= _delta
	else:
		if(Long_Jump):
			if(Jump_Time > 0):
				Jump_Time -= _delta
				slime.velocity.y = slime.speed*Jump_Direction_Vertical*Jump_height*0.3
				slime.velocity.x = slime.speed*Jump_Direction_Horizontal
			else:
				slime.velocity.y =- slime.gravity*slime.speed*Jump_Direction_Vertical*_delta
				if(slime.is_on_ceiling() or slime.is_on_floor()):
					slime.velocity.x = 0
					state_transition.emit(self, "SlimeIdle")
		else:
			if(Jump_Time > 0):
				Jump_Time -= _delta
				slime.velocity.y =+ slime.speed*Jump_height*Jump_Direction_Vertical
			elif (slime.is_on_ceiling() or slime.is_on_floor()):
				slime.velocity.y = 0
				state_transition.emit(self, "SlimeIdle")
		
		


