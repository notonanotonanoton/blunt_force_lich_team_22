extends EnemyBehaviorExtension

@export_category("Nodes")
@export var skeleton_arm : Sprite2D
@export var animation_timer : Timer

@export_category("Values")
@export_range(0, 500, 10) var backdash_strength : int = 300
@export_range(100, 1000, 10) var arrow_speed : int = 300

@onready var arrow = preload("res://enemy/damageobstacle/arrowtrap/Arrow.tscn")

var crossbow_tween : Tween
const crossbow_offset : Vector2 = Vector2(24, 0)


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
	if not enemy.target_player:
		return
	if crossbow_tween:
		crossbow_tween.kill()
	crossbow_tween = self.create_tween()
	
	crossbow_tween.tween_property(skeleton_arm, "rotation_degrees", -90, 0.1)
	
	animation_timer.start(0.2)
	await animation_timer.timeout
	
	var rot : Vector2 = (skeleton_arm.global_position + crossbow_offset *
	 enemy.looking_direction).direction_to(enemy.target_player.global_position)
	
	animation_timer.start(0.1)
	await animation_timer.timeout
	
	var current_arrow : Arrow = arrow.instantiate()
	get_parent().get_parent().add_child(current_arrow)
	current_arrow.add_movement(rot * arrow_speed, (skeleton_arm.global_position + crossbow_offset *
	 enemy.looking_direction), rot)
	#counts on the initial rotation being -90.
	#have to use this instead of tween, as waiting is involved; leads to
	#synchronization issues otherwise
	for frame : int in range(0, 9):
		if frame > 0:
			animation_timer.start(0.01)
		else:
			animation_timer.start(0.1)
		await animation_timer.timeout
		skeleton_arm.rotation_degrees += 10
	
	

func proximity_action(delta : float) -> void:
	enemy.velocity -= Vector2(backdash_strength*enemy.looking_direction, 150)

func jump_action(delta : float) -> void:
	#write action here
	pass
