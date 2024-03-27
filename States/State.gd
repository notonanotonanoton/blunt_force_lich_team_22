extends Node
class_name State #class_name names the class you extended from whatever class. Basically names the class your script represents. 

signal state_transition # Observer, https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass
