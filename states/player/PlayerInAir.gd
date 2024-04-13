extends State
@onready var player_character : CharacterBody2D = $"../.."

func enter() -> void:
	pass # Replace with function body.

func exit() -> void:
	pass

func update(_delta: float) -> void:
	if (player_character.is_on_floor()):
		state_transition.emit(self, "PlayerOnGround")
	
