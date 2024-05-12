extends Node

signal level_transition 
var map_manager : Node
 
func _ready():
	map_manager = 	get_parent().get_parent() 

func _on_area_2d_body_entered(body):
	map_manager.change_scene()	


