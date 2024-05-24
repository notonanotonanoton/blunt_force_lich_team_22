extends State
class_name enemy_aggro
@export_category("Nodes")
@export var enemy : Enemy
@export var attack_timer : Timer
@export var proximity_timer : Timer

@export_category("Values")
#stops moving once within this range. unimplemented for base enemy
@export_range(1, 100, 1) var max_player_proximity : int = 30
@export_range(10, 200, 10) var attack_range : int = 40
@export_range(0.2, 10, 0.1) var attack_rate : float = 2.0
#keep fairly high for intended behavior
@export_range(0, 300, 10) var aggro_range_increase : int = 130

var offset : int
var distance_x_to_player : float = 0.0
var max_attack_rate : float

func _ready() -> void:
	attack_timer.wait_time = attack_rate
	proximity_timer.wait_time = attack_rate
	
	max_attack_rate = attack_rate
	
	await enemy.ready
	offset = enemy.collision_offset
	max_player_proximity += offset

func enter() -> void:
	enemy.aggro_radius.shape.radius = enemy.aggro_range + aggro_range_increase

func exit() -> void:
	enemy.target_player = null
	distance_x_to_player = 0.0
	enemy.aggro_radius.shape.radius = enemy.aggro_range

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	get_distance()
	
	if enemy.is_ranged and distance_x_to_player <= attack_range:
		enemy.stop_move(delta)
	elif not enemy.is_attacking:
		enemy.move(delta, 1.0)
	
	#condition may have to be changed for enemies that want to move and attack at the same time
	if enemy.is_on_floor():
		if distance_x_to_player <= attack_range and attack_timer.is_stopped():
			attack(delta)
	
		if distance_x_to_player <= max_player_proximity and proximity_timer.is_stopped():
			proximity_action(delta)

#enemies should all implement their own attacks.
func attack(delta : float) -> void:
	if enemy.behavior_extension:
		enemy.behavior_extension.attack(delta)
	
	attack_timer.start(randf_range(attack_rate-0.1, attack_rate+0.1))

func proximity_action(delta : float) -> void:
	if enemy.behavior_extension:
		enemy.behavior_extension.proximity_action(delta)
	
	proximity_timer.start(randf_range(attack_rate-0.1, attack_rate+0.1))

func get_distance() -> void:
	var enemy_pos : Vector2 = enemy.global_position
	var enemy_target_pos : Vector2 = enemy.target_player.global_position
	var direction : float = enemy_pos.direction_to(enemy_target_pos).x
	
	distance_x_to_player = abs(enemy_pos.x - enemy_target_pos.x)
	if not enemy.is_attacking:
		if direction < 0.0 and distance_x_to_player >= offset:
			enemy.looking_direction = -1
		elif direction > 0.0 and distance_x_to_player >= offset:
			enemy.looking_direction = 1
	
	

func _on_aggro_radius_body_exited(body : CharacterBody2D) -> void:
	if body is PlayerCharacter:
		state_transition.emit(self, "EnemyIdle")
