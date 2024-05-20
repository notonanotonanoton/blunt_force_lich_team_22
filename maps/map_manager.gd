extends Node

#this will make the map manager ignore the random first level selection.
#input full address from project folder, starting with "res://".
#LEAVE EMPTY IF NORMAL FUNCTION IS DESIRED
var testing_scene = null

var levels : Array
#add more directories whenever needed
var level_directories : PackedStringArray = ["res://maps/Level1/", "res://maps/Level2/", "res://maps/Level3/"]

var current_scene_instance : Node
var level_counter : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_scene : PackedScene
	
	#iterates through all folders specified in level_directories
	for directory : String in level_directories:
		var level_variants_paths : PackedStringArray = DirAccess.open(directory).get_files()
		var level_variants : Array
		for file_name : String in level_variants_paths:
			#var level_variant : PackedScene = load(directory + file_name)
			#level_variants.append(level_variant)
			level_variants.append(load(directory + file_name))
		levels.append(level_variants)
	
	if testing_scene == null:
		first_scene = levels.front().pick_random()
	else:
		first_scene = load(testing_scene)
	
	current_scene_instance = first_scene.instantiate()
	add_child(current_scene_instance)

func change_scene() -> void:
	level_counter += 1
	if level_counter < levels.size():
		remove_child.call_deferred(current_scene_instance)
		current_scene_instance.queue_free()
		
		current_scene_instance = levels[level_counter].pick_random().instantiate()
		add_child(current_scene_instance)
	
