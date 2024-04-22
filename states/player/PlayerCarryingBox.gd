extends State
@onready var player_character : CharacterBody2D = $"../.."
var picked_up_box : CharacterBody2D
var charge_time : float = 0.0
var charging_throw : bool = false
signal request_box

func enter() -> void:
	print("Entered PlayerCarryingBox state")
	
func exit() -> void:
	pass

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("throw_box"):
		if picked_up_box != null:
			charging_throw = true
	
	if charging_throw:
		charge_time += _delta
			
	if (Input.is_action_just_released("throw_box")):
		picked_up_box.thrown_by(player_character, charge_time)
		charge_time = 0.0
		charging_throw = false
		state_transition.emit(self, "playeronground")

			
func _on_area_2d_send_box_status(arg : ) -> void:
	for body in arg:
		if body.name == "pick_up_box":
			picked_up_box = body

func _on_timer_timeout():
	pass # Replace with function body.
