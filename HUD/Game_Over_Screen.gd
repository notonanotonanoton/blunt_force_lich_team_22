extends CanvasLayer

func _ready():
	#set invisible
	#this omega-cancer workaround is here since godot is being cringe and not allowing me to access the visible boolean
	#self.scale = Vector2(0,0)
	visible = false;

func _on_exit_button_pressed():
	print("exit pressed")
	get_tree().quit()
	pass # Replace with function body.


func _on_retry_button_pressed():
	print("retry button pressed")
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_player_character_death():
	#self.scale = Vector2(1, 1)
	visible = true

