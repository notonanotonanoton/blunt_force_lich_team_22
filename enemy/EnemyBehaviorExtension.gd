extends Node

class_name EnemyBehaviorExtension

@export var enemy : Enemy
#use various export variables (change in editor menu only) to fine-tune behavior

#use carefully, can interfere with Enemy.gd
func _ready() -> void:
	pass

#use only for graphical elements
func _process(delta : float) -> void:
	pass

#use VERY carefully, will interfere with Enemy.gd
func _physics_process(delta : float) -> void:
	pass

func attack(delta : float) -> void:
	#write action here
	pass

func proximity_action(delta : float) -> void:
	#write action here
	pass 

func jump_action(delta : float) -> void:
	#write action here
	pass
