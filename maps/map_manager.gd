extends Node

var level1_levels : Array = ["res://maps/Level1/Version1.tscn", "res://maps/Level1/Version2.tscn", "res://maps/Level1/Version3.tscn"]
var level2_levels : Array = ["res://maps/Level2/Version1.tscn", "res://maps/Level2/Version2.tscn", "res://maps/Level2/Version3.tscn"]
var level3_levels : Array = ["res://maps/Level3/Version1.tscn", "res://maps/Level3/Version2.tscn", "res://maps/Level3/Version3.tscn"]
var current_scene : String
var current_scene_instance : Node
@onready var player_character : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_character = $PlayerCharacter
	var next_scene : PackedScene = load("res://mainmenu/MainMenu.tscn")
	current_scene = "res://mainmenu/MainMenu.tscn"
	current_scene_instance = next_scene.instantiate()
	add_child(current_scene_instance)
	
func change_scene(level : int) -> void:
	var new_scene : String
	remove_child.call_deferred(current_scene_instance)
	match level:
		1: 
			new_scene = level1_levels.pick_random()
		2:
			new_scene = level2_levels.pick_random()
		3:
			new_scene = level3_levels.pick_random()
	var next_scene : PackedScene = load(new_scene)
	current_scene = new_scene
	current_scene_instance = next_scene.instantiate()
	add_child(current_scene_instance)
	
func play_tutorial() -> void:
	remove_child.call_deferred(current_scene_instance)
	var next_scene : PackedScene = load("res://maps/TutorialWorld.tscn")
	current_scene = "res://maps/TutorialWorld.tscn"
	current_scene_instance = next_scene.instantiate()
	add_child(current_scene_instance)
	
func restart() -> void: 
	remove_child.call_deferred(current_scene_instance)
	var scene_to_restart : PackedScene = load(current_scene)
	current_scene_instance = scene_to_restart.instantiate()
	add_child(current_scene_instance)
	player_character.on_restart()
