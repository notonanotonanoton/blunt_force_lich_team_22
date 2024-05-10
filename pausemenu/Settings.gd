extends Control

signal back_pressed
signal aiming_arch_toggled 
@onready var window_button : OptionButton = $VBoxContainer/HBoxContainer/WindowMode

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Fullscreen"
]

func _ready():
	add_window_mode_items()
	hide()

func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		window_button.add_item(window_mode)

func _on_window_mode_item_selected(index) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			#Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func _on_pause_menu_entered_settings() -> void:
	show()

func _on_back_pressed() -> void:
	hide()
	emit_signal("back_pressed")
	
func _on_check_box_pressed():
	emit_signal("aiming_arch_toggled")
