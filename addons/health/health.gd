@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Health", "Node", preload("res://addons/health/Health_script.gd"), preload("res://addons/health/Sprite_heart.png"))


func _exit_tree():
	# Clean-up of the plugin goes here.
		remove_custom_type("MyButton")
