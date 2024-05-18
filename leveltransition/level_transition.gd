extends Node

signal level_transition 
var map_manager : Node
var current_level_counter : int = 1

func _ready():
	map_manager = 	get_parent().get_parent() 

func _on_area_2d_body_entered(body):
	map_manager.change_scene(current_level_counter)	
	current_level_counter += 1


