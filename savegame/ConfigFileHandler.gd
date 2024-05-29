extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH : String = "user://settings.ini"

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("aiming_arc", "aiming_arc_toggle", true)
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
func save_video_setting(key: String, value) -> void:
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_video_settings() -> int:
	var video_settings : int = 0
	for key in config.get_section_keys("video"):
		video_settings = config.get_value("video", key)
	return video_settings

func save_aiming_arc_setting(key: String, enabled : bool) -> void:
	config.set_value("aiming_arc", key, enabled)
	config.save(SETTINGS_FILE_PATH)

func load_aiming_arc_setting() -> bool:
	var aiming_arc : bool = true
	for key in config.get_section_keys("aiming_arc"):
		aiming_arc = config.get_value("aiming_arc", key)
	return aiming_arc

func save_vsync_setting(key: String, enabled : bool) -> void:
	config.set_value("vsync", key, enabled)
	config.save(SETTINGS_FILE_PATH)
	
func load_vsync_setting() -> bool:
	var vsync_setting : bool = false
	for key in config.get_section_keys("vsync"):
		vsync_setting = config.get_value("vsync", key)
	return vsync_setting
