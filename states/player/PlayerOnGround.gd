extends State
@onready var player_character : CharacterBody2D = $"../.."
signal request_box_status
var picked_up_box : RigidBody2D

func enter() -> void:
	#print("Entered PlayereOnGround state")
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	if (!player_character.is_on_floor()):
		state_transition.emit(self, "playerinair")
	
	if Input.is_key_pressed(KEY_E):
		emit_signal("request_box_status")
		
func _on_area_2d_send_box_status(arg2) -> void:
	for body in arg2:
		if body.name == "pick_up_box":
			body.picked_up_by(player_character)
			picked_up_box = body
			state_transition.emit(self, "playercarryingbox")
	
