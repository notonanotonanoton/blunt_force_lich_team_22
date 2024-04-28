extends CanvasLayer

func _ready():
	visible = false;

func _on_exit_button_pressed():
	#print("exit pressed")
	get_tree().quit()



func _on_retry_button_pressed():
	#print("retry button pressed")
	get_tree().reload_current_scene()



func _on_player_character_death():
	visible = true

