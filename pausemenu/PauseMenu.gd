extends Control

signal entered_settings
var map_manager : Node
@export var player_character : CharacterBody2D

func _ready() -> void:
	map_manager = get_parent().get_parent()
	hide()

func _process(delta : float) -> void:
	pass

func resume() -> void:
	hide()
	get_tree().paused = false
	
func pause() -> void:
	show()
	get_tree().paused = true 
	
func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause") and !get_tree().paused:
		pause()
	elif event.is_action_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	hide()
	resume()

func _on_restart_pressed() -> void:
	resume()
	map_manager.restart()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	$MenuContainer.set_visible(false)
	emit_signal("entered_settings")
	
func _on_settings_menu_back_pressed() -> void:
	$MenuContainer.set_visible(true)
	show()

func _on_exit_to_main_menu_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://mainmenu/MainMenu.tscn")
