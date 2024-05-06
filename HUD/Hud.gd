extends Node

@export var heart_containers : HBoxContainer
@export var full_heart : Texture2D
@export var half_heart : Texture2D
@export var empty_heart : Texture2D

var character : PlayerCharacter
var health_module : HealthComponent

enum HealthLevel {
	FULL,
	HALF,
}

var max_health : int = 0
var current_health_level : int = HealthLevel.FULL
var current_heart_index : int = 2

func _ready() -> void:
	pass

func _on_children_entered() -> void: 
	await get_tree().create_timer(0.5).timeout
	for node in get_parent().get_children():
		if node is PlayerCharacter:
			character = node
	health_module = character.get_node("Health")
	
	character.health_changed.connect(_on_character_health_changed)
	character.max_health_changed.connect(_on_character_max_health_changed)

func _on_character_health_changed(current_health : int) -> void:
	print(current_health)
	pass

func _on_character_max_health_changed(current_max_health : int) -> void:
	print("max health change")
	#assumes health level is always even
	var heart_count : int = current_max_health / 2
	for child : TextureRect in heart_containers.get_children():
		if child != null:
			child.queue_free()
	for count : int in range(1, heart_count):
		var new_heart : TextureRect = TextureRect.new()
		new_heart.texture = full_heart
		heart_containers.add_child(new_heart)

