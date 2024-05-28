extends Control

signal back_pressed
signal aiming_arc_toggled
var vsync_enabled : bool 
var video_settings : int 
var aiming_arc_enabled : bool
@onready var aiming_arc_checkbox = $VBoxContainer/HBoxContainer3/Aiming_arc
@onready var vsync_checkbox = $VBoxContainer/HBoxContainer4/VSync
@onready var video_settings_menu = $VBoxContainer/HBoxContainer/WindowMode

func _ready() -> void:
	load_settings()
	update_settings_boxes()
	_on_window_mode_item_selected(video_settings)
	_on_v_sync_toggled(vsync_enabled)
	_on_aiming_arc_toggled(aiming_arc_enabled)
	hide()

func load_settings() -> void:
	video_settings = ConfigFileHandler.load_video_settings()
	vsync_enabled = ConfigFileHandler.load_vsync_setting()
	aiming_arc_enabled = ConfigFileHandler.load_aiming_arc_setting()
	
func update_settings_boxes() -> void:
	vsync_checkbox.button_pressed = vsync_enabled
	video_settings_menu.selected = video_settings
	aiming_arc_checkbox.button_pressed = aiming_arc_enabled

func _on_window_mode_item_selected(index : int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			ConfigFileHandler.save_video_setting("video_setting", 0)
		1: #Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			ConfigFileHandler.save_video_setting("video_setting", 1)

func _on_pause_menu_entered_settings() -> void:
	load_settings()
	update_settings_boxes()
	show()

func _on_back_pressed() -> void:
	hide()
	emit_signal("back_pressed")
	
func _on_aiming_arc_toggled(toggled_on) -> void:
	ConfigFileHandler.save_aiming_arc_setting("aiming_arc_toggle", toggled_on)
	emit_signal("aiming_arc_toggled", toggled_on)
	
func _on_main_menu_entered_settings_from_menu() -> void:
	load_settings()
	update_settings_boxes()
	show()

func _on_v_sync_toggled(toggled_on) -> void:
	if (toggled_on):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	ConfigFileHandler.save_vsync_setting("vsync", toggled_on)
