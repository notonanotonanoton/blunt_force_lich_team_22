extends Node

#assumes the "maps" folder exists and only contains level directories
#with scene files of level variants
var maps_directory : String = "res://maps/"
var treasure_levels_directory : String = "res://maps/TreasureLevels"

#this will make the map manager ignore the random first level selection.
#input full address from project folder, starting with "res://".
#LEAVE EMPTY IF NORMAL FUNCTION IS DESIRED
#"res://maps/TestLevel.tscn"
var testing_scene = null

var levels : Array
var treasure_levels : Array[PackedScene] 

var current_scene_instance : Node
#make sure not to exceed the amount of available levels (directories)
@export_range(1, 10, 1) var starting_level_number : int = 1
var level_counter : int

var treasure_check : bool = false

func _ready() -> void:
	level_counter = starting_level_number
	
	for file_name : String in DirAccess.open(treasure_levels_directory).get_files():
		var full_path : String = treasure_levels_directory + "/" + file_name
		full_path = full_path.trim_suffix(".remap")
		treasure_levels.append(load(full_path))
	
	#iterates through all folders specified in level_directories
	for directory : String in DirAccess.open(maps_directory).get_directories():
		if not directory == "TreasureLevels" and not directory == "tutorial":
			var level_variants : Array[PackedScene]
			for file_name : String in DirAccess.open(maps_directory + directory).get_files():
				var full_path : String = maps_directory + directory + "/" + file_name
				full_path = full_path.trim_suffix(".remap")
				var level : PackedScene = load(full_path)
				level_variants.append(level)
			levels.append(level_variants)
	
	var first_scene : PackedScene
	if testing_scene == null:
		first_scene = levels[level_counter - 1].pick_random()
	else:
		first_scene = load(testing_scene as String)
	
	current_scene_instance = first_scene.instantiate()
	add_child(current_scene_instance)

func change_scene() -> void:
	if (not treasure_check) and level_counter % 2 != 0:
		change_map(treasure_levels)
		treasure_check = true
	else:
		level_counter += 1
		if level_counter <= levels.size():
			change_map(levels[level_counter - 1] as Array[PackedScene])
			treasure_check = false

func change_map(level_array : Array[PackedScene]) -> void:
	remove_child.call_deferred(current_scene_instance)
	current_scene_instance.queue_free()
	var new_scene : PackedScene = level_array.pick_random()
	current_scene_instance = new_scene.instantiate()
	add_child(current_scene_instance)
	
func play_tutorial() -> void:
	remove_child(current_scene_instance)
	current_scene_instance.queue_free()
	var next_scene : PackedScene = load("res://maps/tutorial/TutorialWorld.tscn")
	current_scene_instance = next_scene.instantiate()
	add_child(current_scene_instance)
	
func restart() -> void: 
	level_counter = 1
	treasure_check = false
	#there must be a better way of doing this
	if (current_scene_instance.name == 'TutorialWorld'):
		play_tutorial()
	else:
		get_tree().reload_current_scene()
	
