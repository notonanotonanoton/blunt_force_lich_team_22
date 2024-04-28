extends Node

@export var heart_containers : HBoxContainer

enum HealthLevel {
	FULL,
	HALF,
}

var current_health_level = HealthLevel.FULL
var current_heart_index : int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _update_healthbar_on_damage_taken():
	var full_heart = load("res://HUD/heart_container_full.png")
	var half_heart = load("res://HUD/heart_container_half.png")
	var empty_heart = load("res://HUD/heart_container_empty.png")
	var heart = heart_containers.get_child(current_heart_index)
	match current_health_level:
		HealthLevel.FULL:
			current_health_level = HealthLevel.HALF
			heart.texture = half_heart
		HealthLevel.HALF:
			current_health_level = HealthLevel.FULL
			heart.texture = empty_heart
			current_heart_index -= 1
