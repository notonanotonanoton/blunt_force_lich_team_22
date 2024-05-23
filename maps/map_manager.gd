extends Node

#assumes the "maps" folder exists and only contains level directories
#with scene files of level variants
var maps_directory : String = "res://maps/"

#this will make the map manager ignore the random first level selection.
#input full address from project folder, starting with "res://".
#LEAVE EMPTY IF NORMAL FUNCTION IS DESIRED
var testing_scene = null

var levels : Array

var current_scene_instance : Node
#make sure not to exceed the amount of available levels (directories)
@export_range(1, 10, 1) var starting_level_number : int = 1
var level_counter : int

func _ready() -> void:
	level_counter = starting_level_number - 1
	var level_directories : PackedStringArray = DirAccess.open(maps_directory).get_directories()
	
	#iterates through all folders specified in level_directories
	for directory : String in level_directories:
		var level_variants_paths : PackedStringArray = DirAccess.open(maps_directory + directory).get_files()
		var level_variants : Array[PackedScene]
		for file_name : String in level_variants_paths:
			var full_path : String = maps_directory + directory + "/" + file_name
			full_path = full_path.trim_suffix(".remap")
			var level : PackedScene = load(full_path)
			level_variants.append(level)
		levels.append(level_variants)
	
	var first_scene : PackedScene
	if testing_scene == null:
		first_scene = levels[level_counter].pick_random()
	else:
		first_scene = load(testing_scene as String)
	
	current_scene_instance = first_scene.instantiate()
	add_child(current_scene_instance)

func change_scene() -> void:
	level_counter += 1
	if level_counter < levels.size():
		remove_child.call_deferred(current_scene_instance)
		current_scene_instance.queue_free()
		
		var new_scene : PackedScene = levels[level_counter].pick_random()
		current_scene_instance = new_scene.instantiate()
		add_child(current_scene_instance)
	
