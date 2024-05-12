extends Node

func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://level2.01.tscn") #update to choose randomly from array when there  are more levels available 

