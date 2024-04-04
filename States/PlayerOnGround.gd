extends State
class_name PlayerOnGround
@onready var player_character = $"../.."
signal request_box_status
var picked_up_box : RigidBody2D

func enter():
	print("Entered PlayereOnGround state")

func exit():
	pass

func update(_delta: float):
	if (!player_character.is_on_floor()):
		state_transition.emit(self, "playerinair")
	
	if Input.is_key_pressed(KEY_E):
		emit_signal("request_box_status")
		
func _on_area_2d_send_box_status(arg2):
	for body in arg2:
		if body.name == "pick_up_box":
			body.picked_up_by(player_character)
			picked_up_box = body
			state_transition.emit(self, "playercarryingbox")
	
