extends Control

signal entered_settings_from_menu
var map_manager : Node
var pause_action
# Called when the node enters the scene tree for the first time.
func _ready(): #TODO: turn off filtering for image or swap it out to some color
	map_manager = get_parent().get_parent()
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
	print("play pressed")
	map_manager.change_scene()
	enable_pause_action()
	hide()

func _on_tutorial_pressed() -> void:
	print("play tutorial pressed")
	map_manager.play_tutorial()
	enable_pause_action()
	hide()

func _on_settings_pressed() -> void:
	$MarginContainer/VBoxContainer.set_visible(false)
	emit_signal("entered_settings_from_menu")

func _on_settings_back_pressed():
	$MarginContainer/VBoxContainer.set_visible(true)
	print("settings back pressed connected to main menu")

func _on_exit_pressed():
	get_tree().quit()
