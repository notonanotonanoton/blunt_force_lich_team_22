extends CharacterBody2D

@export var speed = 15

@export var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	move_and_slide()

