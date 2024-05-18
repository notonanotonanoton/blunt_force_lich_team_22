extends Control

var map_manager : Node
# Called when the node enters the scene tree for the first time.
func _ready(): #TODO: turn off filtering for image or swap it out to some color
	map_manager = get_parent().get_parent()
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_pressed() -> void:
	print("play pressed")
	map_manager.change_scene(1)
	hide()

func _on_tutorial_pressed() -> void:
	print("play tutorial pressed")
	map_manager.play_tutorial()
	hide()

func _on_settings_pressed() -> void:
	pass # Replace with function body.
