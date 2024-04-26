extends TileMap

class_name interactive_tilemap



@export var TILE_SCENES: Dictionary = {
	#insert the atlas coordinate of the spawner and the filepath to the object it should spawn
	Vector2i(0,0): preload("res://playercharacter/PlayerCharacter.tscn"),
	Vector2i(1,0): preload("res://enemy/Enemy.tscn"),
	Vector2i(2,0): preload("res://playerbox/PlayerBox.tscn") 
}

#decrement global pos with this if you want to start in the corner of the tile
#i dont know what data type this is
@onready var half_cell_size := tile_set.tile_size * 0.5

var search_layer : int = 0

func _ready() -> void:

	_replace_tiles_with_scene()


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

