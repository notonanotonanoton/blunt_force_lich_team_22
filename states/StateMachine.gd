extends Node
class_name statemachine
@export var inital_state : State

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children(): #returns an array to the nodes children
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
			 
	if inital_state:
		inital_state.enter()
		current_state = inital_state
		
func _process(delta) -> void:
	if current_state:
		current_state.update(delta)
	
func state_physics_process(delta) -> void:
	if current_state:
		current_state.physics_update(delta)
		
func change_state(old_state : State, new_state_name : String) -> void:
	#print("changed state to: " + new_state_name)
	if old_state != current_state:
		return
		
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
	
	current_state = new_state