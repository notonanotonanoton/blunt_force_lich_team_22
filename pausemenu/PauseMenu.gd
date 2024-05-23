extends Control

signal entered_settings

func _ready() -> void:
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
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	$MenuContainer.set_visible(false)
	emit_signal("entered_settings")
	
func _on_settings_menu_back_pressed() -> void:
	$MenuContainer.set_visible(true)
	show()
