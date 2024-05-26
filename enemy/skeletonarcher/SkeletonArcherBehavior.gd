extends EnemyBehaviorExtension

@export_category("Nodes")
@export var skeleton_arm : Sprite2D
@export var animation_timer : Timer

@export_category("Values")
@export_range(0, 500, 10) var backdash_strength : int = 300
@export_range(100, 1000, 10) var arrow_speed : int = 300

@onready var arrow : PackedScene = preload("res://enemy/damageobstacle/arrowtrap/Arrow.tscn")

var crossbow_tween : Tween
const crossbow_offset : Vector2 = Vector2(28, 0)


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

#things like getting the position of the arm cannot be saved in this function
#as it needs to update the position after waiting for the timer
func attack(delta : float) -> void:
	enemy.is_attacking = true
	
	if crossbow_tween:
		crossbow_tween.kill()
	crossbow_tween = self.create_tween()
	
	crossbow_tween.tween_property(skeleton_arm, "rotation_degrees", -90, 0.1)
	
	animation_timer.start(0.2)
	await animation_timer.timeout
	
	var rot : Vector2
	if not enemy.target_player:
		return
	else:
		rot = (skeleton_arm.global_position + crossbow_offset *
		enemy.looking_direction).direction_to(enemy.target_player.global_position + Vector2(0, -4))
	
	animation_timer.start(0.1)
	await animation_timer.timeout
	
	var current_arrow : Arrow = arrow.instantiate()
	enemy.get_parent().add_child(current_arrow)	
	#print(rot * arrow_speed)
	current_arrow.add_movement(rot * arrow_speed, (skeleton_arm.global_position + crossbow_offset *
	enemy.looking_direction))
	crossbow_tween = self.create_tween()
	crossbow_tween.tween_property(skeleton_arm, "rotation_degrees", 0, 0.1)
	
	await crossbow_tween.finished
	enemy.is_attacking = false
	

func proximity_action(delta : float) -> void:
	var timer : SceneTreeTimer = get_tree().create_timer(0.2)
	enemy.velocity -= Vector2(backdash_strength*enemy.looking_direction, 150)
	await timer.timeout
	enemy.stop_move(delta)
	enemy.stop_move(delta)
	

func jump_action(delta : float) -> void:
	#write action here
	pass
