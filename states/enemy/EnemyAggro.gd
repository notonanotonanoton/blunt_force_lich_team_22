extends State

@export_category("Nodes")
@export var enemy : Enemy
@export var attack_timer : Timer

@export_category("Values")
#stops moving once within this range
@export_range(1, 100, 1) var max_player_proximity : int = 4
@export_range(10, 200, 10) var attack_range : int = 40
@export_range(0.2, 10, 0.1) var attack_speed : float = 2.0
@export_range(0, 300, 10) var aggro_range_increase : int = 50

var distance_to_player : float = 0.0

func _ready() -> void:
	attack_timer.wait_time = attack_speed

func enter() -> void:
	print("Entered enemy aggro")
	enemy.aggro_radius.shape.radius += aggro_range_increase

func exit() -> void:
	print("Exited enemy aggro")
	enemy.target_player = null
	distance_to_player = 0.0
	enemy.aggro_radius.shape.radius -= aggro_range_increase

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	get_distance()
	
	if(distance_to_player > max_player_proximity):
		enemy.move(delta)
	elif(abs(enemy.velocity.x) > 0):
		enemy.stop_move(delta)
	#condition may have to be changed for enemies that want to move and attack at the same time
	if(distance_to_player < attack_range and attack_timer.is_stopped()):
		attack(delta)

#enemies should all implement their own attacks.
#this is an example simulating a rough idea of a slime jumping at a player
func attack(delta : float) -> void:
	
	#maybe add charge-up timer here?
	
	enemy.jump()
	enemy.velocity.x = move_toward(enemy.velocity.x, 
	enemy.move_direction * enemy.speed, enemy.speed * 5)
	
	if(attack_speed > 1.5):
		attack_timer.start(randf_range(attack_speed-0.5, attack_speed+0.5))
	else:
		attack_timer.start(randf_range(attack_speed-0.1, attack_speed+0.1))

func get_distance() -> void:
	distance_to_player = Vector2(enemy.global_position.x,
	 0).distance_to(Vector2(enemy.target_player.global_position.x, 0))
	
	if(enemy.global_position.direction_to(enemy.target_player.global_position).x < 0):
		enemy.move_direction = -1
	else:
		enemy.move_direction = 1

func _on_aggro_radius_body_exited(body : PlayerCharacter) -> void:
	state_transition.emit(self, "EnemyIdle")
