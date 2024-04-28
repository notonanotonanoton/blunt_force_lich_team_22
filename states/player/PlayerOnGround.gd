extends State
@onready var player_character : CharacterBody2D = $"../.."
signal request_box_status
var picked_up_box : CharacterBody2D

func enter() -> void:
	#print("Entered PlayereOnGround state")
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	if (!player_character.is_on_floor()):
		state_transition.emit(self, "playerinair")
