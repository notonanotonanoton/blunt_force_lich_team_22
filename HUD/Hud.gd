extends Node

@export var heart_containers : HBoxContainer
@export var full_heart : Texture2D
@export var half_heart : Texture2D
@export var empty_heart : Texture2D

#this has to be replaced or altered with something
#that works even after replacing the tilemap 

@onready var heart_rect : PackedScene = preload("res://HUD/HeartRect.tscn")

@export var character : PlayerCharacter
var health_module : HealthComponent

enum HealthLevel {
	FULL,
	HALF,
}

var current_max_health : int 
var current_health_level : int = HealthLevel.FULL
var current_heart_index : int 
var current_heart : TextureRect

func _ready() -> void:
	current_heart_index = heart_containers.get_child_count() - 1
	health_module = character.get_node("Health")
	current_max_health = health_module.get_max_health()
	character.health_changed.connect(_on_character_health_changed)
	character.max_health_changed.connect(_on_character_max_health_changed)
	health_module.heart_picked_up.connect(_on_heart_picked_up)
	_load_hearts()
	
func _load_hearts() -> void:
	for child : TextureRect in heart_containers.get_children():
			if child != null:
				child.queue_free()
	await get_tree().create_timer(0.1).timeout
	var heart_count : int = health_module.get_max_health() / 2
	for count : int in range(heart_count):
		var new_heart : TextureRect = heart_rect.instantiate()
		new_heart.texture = full_heart
		heart_containers.add_child(new_heart)
	
func _on_character_health_changed(damage : int) -> void: 
	current_heart = heart_containers.get_child(current_heart_index)
	match current_health_level:
		HealthLevel.FULL:
			current_health_level = HealthLevel.HALF
			current_heart.texture = half_heart
		HealthLevel.HALF:
			current_health_level = HealthLevel.FULL
			current_heart.texture = empty_heart
			current_heart_index -= 1

func _on_heart_picked_up() -> void:
	_refresh_healthbar()

func _on_character_max_health_changed(new_max_health : int) -> void:
	#assumes health level is always even
	print("max health change")
	if (new_max_health > current_max_health and new_max_health >= health_module.get_health()):
		var new_heart : TextureRect = heart_rect.instantiate()
		heart_containers.add_child(new_heart)
	else:
		for child : TextureRect in heart_containers.get_children():
			if child != null:
				child.queue_free()
		await get_tree().create_timer(0.1).timeout #använda free istället för queue free?
		for count : int in range(0, new_max_health / 2):
			var new_heart : TextureRect = heart_rect.instantiate()
			heart_containers.add_child(new_heart)
	_refresh_healthbar()
	
func _refresh_healthbar() -> void:
	current_heart_index = 0
	var health : int = health_module.get_health()
	var i : int = 0
	while i < heart_containers.get_child_count():
		current_heart = heart_containers.get_child(i)
		if health >= 2:
			current_heart.texture = full_heart
			current_health_level = HealthLevel.FULL
		elif health == 1:
			current_heart.texture = half_heart
			current_health_level = HealthLevel.HALF
		else:
			current_heart.texture = empty_heart
		health -= 2
		i += 1
		if (health > 0):
			current_heart_index += 1
	
func _on_player_character_reset_hp():
	print("yes")
	_refresh_healthbar()
