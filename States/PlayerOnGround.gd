extends State
class_name PlayerOnGround
@onready var player_character = $"../.."


func enter():
	print("Entered PlayereOnGround state")

func exit():
	pass

func update(_delta: float):
	if (!player_character.is_on_floor()):
		state_transition.emit(self, "playerinair")
	
