extends Resource
class_name Enemy_Template

@export_range(0, 10, 1) var damage : int = 1
@export_range(1, 50, 1) var health : int = 3
@export_range(0, 400, 10) var speed : float = 200
@export_range(0, 1, 0.1) var acceleration : float = 0.5
@export_range(0, 1000, 25) var jump_strength : float = 500
@export_range(0, 1, 0.1) var friction : float = 0.5
