extends State
class_name PlayerInAir
@onready var player_character = $"../.."

func enter():
	print("Entered PlayerInAir state")
	pass # Replace with function body.

func exit():
	pass

func update(_delta: float):
	if (player_character.is_on_floor()):
		state_transition.emit(self, "playeronground")
	
