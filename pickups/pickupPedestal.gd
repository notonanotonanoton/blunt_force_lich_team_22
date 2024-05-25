extends Node2D

var available_items : Array[PackedScene]

#I'm not sure if we want every item to be available from the start. So instead i'll just allow the person making the maps to figure out that choice

@export var allow_invincibility : bool = true
@export var allow_PermanentHealthUp : bool = true
@export var allow_SlowEnemies : bool = true
@export var allow_SpikeImmunity : bool = true
@export var allow_Thorns : bool = true


var first_time_player_entered : bool = true
var amount_of_player_health_pickUps : int = 0;


func _on_area_2d_body_entered(body):
	print("PLAYER DETECTED SPAWNING ITEM")
	if body is PlayerCharacter and first_time_player_entered:
		
		first_time_player_entered = false;
		
		check_for_duplicates(body)
		
		add_allowed_items_to_spawn_pool()
		
		spawn_random_item()


func spawn_random_item():
	var item_to_spawn = available_items.pick_random()
	var scene = item_to_spawn.instantiate()
	add_sibling(scene)
	
	scene.global_position = self.global_position+Vector2(0, -20)
	
func add_allowed_items_to_spawn_pool():
	if allow_invincibility == true:
		available_items.append(preload("res://pickups/powerUp/InvincibilityExtender/InvincibilityExtender.tscn"))
	if allow_PermanentHealthUp == true:
		available_items.append(preload("res://pickups/powerUp/PermanentHealthUp/healthUp.tscn"))
	if allow_SlowEnemies:
		available_items.append(preload("res://pickups/powerUp/SlowEnemies/SlowEnemies.tscn"))
	if allow_SpikeImmunity:
		available_items.append(preload("res://pickups/powerUp/spikeImmunity/spikeImmunity.tscn"))
	if allow_Thorns:
		available_items.append(preload("res://pickups/powerUp/Thorns/ThornsItem.tscn"))

func check_for_duplicates(player_char : PlayerCharacter):
	for item in player_char.items:
		if item is Slow_Enemies:
			allow_SlowEnemies = false;
		if item is PermanentHealthPickup:
			amount_of_player_health_pickUps = amount_of_player_health_pickUps+1
		if item is InvincibilityExtender:
			allow_invincibility = false;
		if item is ThornsItem:
			allow_Thorns = false;
	if amount_of_player_health_pickUps >= 2:
		allow_PermanentHealthUp = false;
