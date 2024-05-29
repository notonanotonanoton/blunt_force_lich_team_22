extends Node

signal level_transition 
var map_manager : Node
 
func _ready() -> void:
	map_manager = get_parent().get_parent().get_parent()

func _on_area_2d_body_entered(_body : Node2D) -> void:
	map_manager.tutorial_exit()



