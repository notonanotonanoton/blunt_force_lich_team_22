extends TileMap

class_name interactive_tilemap

@export var enemy : String 

@export var TILE_SCENES: Dictionary = {
	#insert the atlas coordinate of the spawner and the filepath to the object it should spawn
	#player is commented out so we know the spot is reserved. It should not be handled with the other tile scenes
	#since its being handled by its own script 
	#Vector2i(0,0): preload("res://playercharacter/PlayerCharacter.tscn"),
	
	#Vector2i(1, 0): preload()
	Vector2i(1,0): preload("res://leveltransition/LevelTransition.tscn"),
	Vector2i(0,1): preload("res://enemy/slime/Slime.tscn"),
	Vector2i(1,1): preload("res://enemy/skeletonarcher/SkeletonArcher.tscn"),
	#Vector2i(2,1): preload()
	Vector2i(0,2): preload("res://enemy/damageobstacle/Spikes.tscn"),
	Vector2i(1,2): preload("res://enemy/damageobstacle/arrowtrap/Arrow.tscn"),
	Vector2i(0,3): preload("res://graveyardtiles/breakableblocks/BreakableBlockRock.tscn"),
	Vector2i(1,3): preload("res://graveyardtiles/breakableblocks/BreakableBlockStone.tscn")
}

#decrement global pos with this if you want to start in the corner of the tile
@onready var half_cell_size : Vector2 = tile_set.tile_size * 0.5

var search_layer : int = 0

func _ready() -> void:
	_replace_tiles_with_scene()
	teleport_player_to_spawn()
	


func _replace_tiles_with_scene(scene_dictionary: Dictionary = TILE_SCENES) -> void:
	#for every atlas coordinate in the dictionary
	
	for key : Vector2i in scene_dictionary.keys():
		
		#for all the cell IDs found matching the atlas coordinate
		for tile_pos : Vector2i in get_used_cells_by_id(search_layer, 0, key):
			set_cell(search_layer, tile_pos, -1)
			#We deferr the call so all of the scenes can be processed instead of being overwritten
			var object_scene : PackedScene = scene_dictionary[key]
			var object : Node2D = object_scene.instantiate()
			get_parent().add_child.call_deferred(object)
			#adjust scene position to match the tile location instead of default spawn location
			object.global_position = map_to_local(tile_pos)
	

func teleport_player_to_spawn() -> void:
	#this should not return more than 1, but the default return is an array so we do this as a workaround
	for tile_pos : Vector2i in get_used_cells_by_id(search_layer, 0, Vector2i(0,0)):
		set_cell(search_layer, tile_pos, -1)
		for child : Node in get_parent().get_parent().get_children():
			if child is PlayerCharacter:

				child.teleport_player(to_global(map_to_local(tile_pos)))
				
				#print("moved player to spawn")
	

