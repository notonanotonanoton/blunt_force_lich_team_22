extends State

@export_category("Nodes")
@export var enemy : Enemy
@export var timer : Timer
@export var timer_move : Timer

@export_category("Values")
@export_range(0, 5, 1) var move_duration : int = 3
@export_range(2, 10, 1) var idle_duration : int = 2

func _ready() -> void:
	timer.wait_time = idle_duration

func enter() -> void:
	#print("Entered enemy idle")
	timer.start()

func exit() -> void:
	#print("Exited enemy idle")
	timer.stop()
	timer_move.stop()

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	enemy.velocity.x += 10
	if(timer.is_stopped()):
		enemy.move(delta, 0.5)
	elif(abs(enemy.velocity.x) > 0):
		enemy.stop_move(delta)

func _on_aggro_radius_body_entered(body : CharacterBody2D) -> void:
	if body is PlayerCharacter:
		enemy.target_player = body
		state_transition.emit(self, "EnemyAggro")

func _on_idle_timer_timeout() -> void:
	#print("idle timeout")
	#throws away results of 0 in setter func
	enemy.looking_direction = randi_range(-1, 1)
	timer_move.start()

func _on_idle_timer_move_timeout() -> void:
	#print("idle move timeout")
	#randomizes wait time before move
	timer.start(randi_range(idle_duration-1, idle_duration+1))
