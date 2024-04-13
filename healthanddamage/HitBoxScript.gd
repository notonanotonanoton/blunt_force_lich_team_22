extends Area2D
class_name  hit_box_component

@export var health_component : Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage(damage : int, enemy_position : Vector2):
	if health_component:
		health_component.take_damage(damage, enemy_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	pass
	

