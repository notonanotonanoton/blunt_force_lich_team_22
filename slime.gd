extends CharacterBody2D

@export var speed = 15
var dirU = 1
var dirR = 1
var checkone = true
var check2 = false
var count = 0
var player = null
var player_chase = false



@export var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	move_and_slide()

