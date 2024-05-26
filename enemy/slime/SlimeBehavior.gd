extends EnemyBehaviorExtension

#has access to Enemy.gd functions through extending EnemyBehaviorExtension.gd.
#not all functions are not suitable for extension use.
#use various export variables (change in editor menu only) to fine-tune behavior

#use carefully, can interfere with Enemy.gd
func _ready() -> void:
	pass

#use only for graphical elements
func _process(delta : float) -> void:
	pass

#use VERY carefully, will interfere with Enemy.gd
func _physics_process(delta : float) -> void:
	pass

func attack(delta : float) -> void:
	enemy.is_attacking = true
	var timer : SceneTreeTimer = get_tree().create_timer(0.2)
	#write action here
	enemy.jump(delta, 0.5, true)
	
	await timer.timeout
	enemy.is_attacking = false

func proximity_action(delta : float) -> void:
	#write action here
	pass 

func jump_action(delta : float) -> void:
	enemy.velocity.x = 200 * enemy.looking_direction
