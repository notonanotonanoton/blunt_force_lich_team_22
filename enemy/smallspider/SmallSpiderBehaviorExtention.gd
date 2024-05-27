extends EnemyBehaviorExtension

#use various export variables (change in editor menu only) to fine-tune behavior

#use carefully, can interfere with Enemy.gd

#This is used so that the spider swarmlings don't get stuck in each other reducing the risk of them to be multi killed
func _ready() -> void:
	enemy.speed = randi_range(50,90)
	pass

#use only for graphical elements
func _process(delta : float) -> void:
	pass

#use VERY carefully, will interfere with Enemy.gd
func _physics_process(delta : float) -> void:
	pass

func attack(delta : float) -> void:
	#write action here
	pass

func proximity_action(delta : float) -> void:
	#write action here
	pass 

func jump_action(delta : float) -> void:
	#write action here
	pass
