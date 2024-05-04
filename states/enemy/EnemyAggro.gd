extends State

@export_category("Nodes")
@export var enemy : Enemy
@export var attack_timer : Timer
@export var proximity_timer : Timer

@export_category("Values")
#stops moving once within this range. unimplemented for base enemy
@export_range(1, 100, 1) var max_player_proximity : int = 30
@export_range(10, 200, 10) var attack_range : int = 40
@export_range(0.2, 10, 0.1) var attack_speed : float = 2.0
@export_range(0, 300, 10) var aggro_range_increase : int = 80

var offset : int
var distance_to_player : float = 0.0

func _ready() -> void:
	attack_timer.wait_time = attack_speed
	proximity_timer.wait_time = attack_speed
	
	await enemy.ready
	offset = enemy.collision_offset
	max_player_proximity += offset

func enter() -> void:
	enemy.aggro_radius.shape.radius += aggro_range_increase
	enemy.flip_gravity(false)

func exit() -> void:
	enemy.target_player = null
	distance_to_player = 0.0
	enemy.aggro_radius.shape.radius -= aggro_range_increase

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	get_distance()
	enemy.move(delta, 1.0)
	
	#condition may have to be changed for enemies that want to move and attack at the same time
	if distance_to_player <= attack_range and attack_timer.is_stopped():
		attack(delta)
	
	if distance_to_player <= max_player_proximity and proximity_timer.is_stopped():
		proximity_action(delta)

#enemies should all implement their own attacks.
func attack(delta : float) -> void:
	if enemy.behavior_extension:
		enemy.behavior_extension.attack(delta)
	
	attack_timer.start(randf_range(attack_speed-0.1, attack_speed+0.1))

func proximity_action(delta : float) -> void:
	var behavior : EnemyBehaviorExtension = enemy.behavior_extension
	
	if behavior != null:
		behavior.proximity_action(delta)
	
	proximity_timer.start(randf_range(attack_speed-0.1, attack_speed+0.1))

func get_distance() -> void:
	var enemy_pos : Vector2 = enemy.global_position
	var enemy_target_pos : Vector2 = enemy.target_player.global_position
	var direction : float = enemy_pos.direction_to(enemy_target_pos).x
	
	distance_to_player = Vector2(enemy_pos.x, 0).distance_to(Vector2(enemy_target_pos.x, 0))
	if direction < 0.0 and distance_to_player >= offset:
		enemy.looking_direction = -1
	elif direction > 0.0 and distance_to_player >= offset:
		enemy.looking_direction = 1
	
	

func _on_aggro_radius_body_exited(body : CharacterBody2D) -> void:
	if body is PlayerCharacter:
		state_transition.emit(self, "EnemyIdle")
