extends State

@export_category("Nodes")
@export var enemy : Enemy
@export var timer : Timer
@export var timer_move : Timer
@onready var jump_timer : Timer = $HighJumpTimer

@export_category("Values")
@export_range(0, 5, 1) var move_duration : int = 3
@export_range(2, 10, 1) var idle_duration : int = 2

func _ready() -> void:
	timer.wait_time = idle_duration

func enter() -> void:
	#print("Entered enemy idle")
	timer.start()
	jump_timer.start(enemy.highJumpTime)

func exit() -> void:
	#print("Exited enemy idle")
	timer.stop()
	timer_move.stop()
	jump_timer.stop()

func update(delta : float) -> void:
	pass

func physics_update(delta : float) -> void:
	if(timer.is_stopped()):
		enemy.move(delta)
	elif(abs(enemy.velocity.x) > 0):
		enemy.stop_move(delta)

func _on_aggro_radius_body_entered(body : Node2D):
	if (body == PlayerCharacter):
		enemy.target_player = body
		print("player entered aggro")
		state_transition.emit(self, "EnemyAggro")

func _on_idle_timer_timeout():
	#print("idle timeout")
	#throws away results of 0 in setter func
	enemy.looking_direction = randi_range(-1, 1)
	timer_move.start()

func _on_idle_timer_move_timeout():
	#print("idle move timeout")
	#randomizes wait time before move
	timer.start(randi_range(idle_duration-1, idle_duration+1))

#High jump timer
func _on_timer_timeout():
	enemy.highJump()
	jump_timer.start(enemy.highJumpTime)
	pass # Replace with function body.
