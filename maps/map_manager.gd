extends Node

var level1_levels : Array = ["res://Level1.01.tscn", "res://level1.02.tscn", "res://level1.03.tscn"]
var level2_levels : Array = ["res://level2.01.tscn"]
var current_scene_instance : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_scene : String = level1_levels.pick_random()
	var next_scene : PackedScene = load("res://level1.01.tscn") #current testing level update when want 
	current_scene_instance = next_scene.instantiate()
	add_child(current_scene_instance)

func change_scene() -> void:
	remove_child.call_deferred(current_scene_instance)
	var new_scene : String = level1_levels.pick_random()
	var next_scene : PackedScene = load(new_scene)
	current_scene_instance = next_scene.instantiate()
	add_child(current_scene_instance)