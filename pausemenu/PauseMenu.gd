extends Control

signal entered_settings
var map_manager : Node

func _ready():
	map_manager = get_parent().get_parent()
	hide()

func _process(delta):
	pass

func resume() -> void:
	hide()
	get_tree().paused = false
	
func pause() -> void:
	show()
	get_tree().paused = true 
	
func _input(event):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
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

func _on_exit_to_main_menu_pressed():
	resume()
	get_tree().reload_current_scene() #runs the ready method in mapmanager loading the mainmenu
