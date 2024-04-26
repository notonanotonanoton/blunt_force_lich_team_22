extends CharacterBody2D
class_name Slime

@export var speed = 15
@export var just_jumped : bool
@export_range(0, 1, 0.1) var acceleration = 1

@export var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta : float) -> void:
	
	move_and_slide()

