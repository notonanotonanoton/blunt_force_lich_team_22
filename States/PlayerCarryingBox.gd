extends State
class_name PlayerCarryingBox
@onready var player_character = $"../.."
var picked_up_box : RigidBody2D
signal request_box

func enter():
	print("Entered PlayerCarryingBox state")

func exit():
	pass

func update(_delta: float):
	if Input.is_key_pressed(KEY_T) and player_character.is_on_floor():
		if picked_up_box != null:
			picked_up_box.thrown_by(player_character)
			state_transition.emit(self, "playeronground")
			
func _on_area_2d_send_box_status(arg2):
	for body in arg2:
		if body.name == "pick_up_box":
			picked_up_box = body
