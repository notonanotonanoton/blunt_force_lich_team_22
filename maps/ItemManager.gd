extends Node2D

class_name ItemManager

var default_item : PackedScene = preload("res://pickups/powerUp/PermanentHealthUp/healthUp.tscn")

var items : Array[PackedScene] = [default_item,
preload("res://pickups/powerUp/InvincibilityExtender/InvincibilityExtender.tscn"),
preload("res://pickups/powerUp/SlowEnemies/SlowEnemies.tscn"),
preload("res://pickups/powerUp/spikeImmunity/SpikeImmunity.tscn"),
preload("res://pickups/powerUp/Thorns/ThornsItem.tscn")]

var available_items : Array[Node2D]

func _ready() -> void:
	for item : PackedScene in items:
		var instantiated_item : Node2D = item.instantiate()
		available_items.append(instantiated_item)
		#add a second max health pickup
		if instantiated_item is PermanentHealthPickup:
			available_items.append(item.instantiate())
		

func get_random_item() -> Node2D:
	var item : Node2D
	if available_items.is_empty():
		item = default_item.instantiate()
	else:
		item = available_items.pick_random()
		available_items.erase(item)
	return item
