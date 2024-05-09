extends Control

func _ready():
	hide()

func _process(delta):
	pass

func resume():
	hide()
	get_tree().paused = false
	
func pause():
	show()
	get_tree().paused = true 
	
func _input(event):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed():
	hide()
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_exit_pressed():
	get_tree().quit()
