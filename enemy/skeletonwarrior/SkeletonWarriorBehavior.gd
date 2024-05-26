extends EnemyBehaviorExtension

@export_category("Nodes")
@export var sprites : Sprite2D
@export var arm : Sprite2D
@export var arm_collision : CollisionShape2D
@export var animation_timer : Timer

@export_category("Values")
@export_range(0, 500, 10) var smash_dash_speed : int = 200

var smash_tween : Tween

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
	
	if smash_tween:
		smash_tween.kill()
	smash_tween = self.create_tween()
	
	smash_tween.tween_property(arm, "rotation_degrees", -240, 0.3)
	smash_tween.parallel().tween_property(sprites, "rotation_degrees", -30, 0.2)
	smash_tween.tween_property(arm, "scale:y", 3, 0.2)
	smash_tween.parallel().tween_property(arm, "scale:x", 2, 0.2)
	
	animation_timer.start(0.5)
	await animation_timer.timeout
	
	arm_collision.set_deferred("disabled", false)
	smash_tween = self.create_tween()
	
	
	
	smash_tween.tween_property(arm, "rotation_degrees", -60, 0.1)
	smash_tween.parallel().tween_property(sprites, "rotation_degrees", 60, 0.1)
	smash_tween.parallel().tween_property(arm, "position:x", 8, 0.1)
	
	await smash_tween.finished
	
	enemy.velocity = Vector2i(smash_dash_speed * enemy.looking_direction, -200)
	smash_tween = self.create_tween()
	
	smash_tween.tween_property(arm, "scale:y", 1, 0.1).set_delay(0.1)
	smash_tween.parallel().tween_property(arm, "scale:x", 1, 0.1).set_delay(0.1)
	
	await smash_tween.finished
	
	arm_collision.set_deferred("disabled", true)
	smash_tween = self.create_tween()
	
	smash_tween.tween_property(arm, "rotation_degrees", 0, 0.1)
	smash_tween.parallel().tween_property(sprites, "rotation_degrees", 0, 0.1)
	smash_tween.parallel().tween_property(arm, "position:x", -4, 0.1)
	
	#every call only gradually slows down. needed to stop from gliding too fast
	enemy.stop_move(delta)
	enemy.stop_move(delta)
	enemy.stop_move(delta)
	
	await smash_tween.finished
	enemy.is_attacking = false

func proximity_action(delta : float) -> void:
	#write action here
	pass 

func jump_action(delta : float) -> void:
	#write action here
	pass
