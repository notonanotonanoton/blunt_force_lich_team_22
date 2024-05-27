extends Control

signal back_pressed
signal aiming_arc_toggled
var vsync_enabled : bool = true

func _ready() -> void:
	print("ready in settings menu")
	hide()

func _on_window_mode_item_selected(index : int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

func _on_pause_menu_entered_settings() -> void:
	show()

func _on_back_pressed() -> void:
	hide()
	emit_signal("back_pressed")
	
func _on_check_box_pressed() -> void:
	emit_signal("aiming_arc_toggled")

func _on_v_sync_pressed() -> void:
	if (!vsync_enabled):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		vsync_enabled = true
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		vsync_enabled = false

func _on_main_menu_entered_settings_from_menu() -> void:
	show()
