extends Control

signal entered_settings_from_menu
var MapManagerScene = preload("res://maps/MapManager.tscn")

var pause_action
# Called when the node enters the scene tree for the first time.
func _ready(): #TODO: turn off filtering for image or swap it out to some color
	disable_pause_action()
	#show()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.

func enable_pause_action() -> void:
	for action in pause_action:
		InputMap.action_add_event("pause", action)
	
func disable_pause_action() -> void:
	pause_action = InputMap.action_get_events("pause")
	InputMap.action_erase_events("pause")

func _process(delta):
	pass

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://maps/MapManager.tscn")
	enable_pause_action()
	hide()

func _on_tutorial_pressed() -> void:
	enable_pause_action()
	var map_manager_instance = MapManagerScene.instantiate()
	add_child(map_manager_instance)
	enable_pause_action()
	$PanelContainer.set_visible(false)
	#hide()
	map_manager_instance.play_tutorial()

func _on_settings_pressed() -> void:
	$PanelContainer/MarginContainer/VBoxContainer.set_visible(false)
	emit_signal("entered_settings_from_menu")

func _on_settings_back_pressed():
	$PanelContainer/MarginContainer/VBoxContainer.set_visible(true)

func _on_exit_pressed():
	get_tree().quit()
