extends CanvasLayer

func _ready() -> void:
	visible = false;

func _on_exit_button_pressed() -> void:
	#print("exit pressed")
	get_tree().quit()

func _on_retry_button_pressed() -> void:
	#print("retry button pressed")
	get_tree().reload_current_scene()

func _on_player_character_player_death() -> void:
	visible = true
