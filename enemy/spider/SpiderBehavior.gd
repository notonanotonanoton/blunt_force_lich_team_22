extends EnemyBehaviorExtension

@export_category("Nodes")
@export var animation_target : Node2D
@export var sprite : Sprite2D
@export var animation_timer : Timer

@export_category("Values")
@export_range(0, 500, 10) var backdash_strength : int = 300
@export_range(0.5, 5, 0.5) var summon_speed : float = 1.0

@onready var small_spider : PackedScene = preload("res://enemy/smallspider/SmallSpider.tscn")

var summon_spider_tween : Tween

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
	
	if summon_spider_tween:
		summon_spider_tween.kill()
	summon_spider_tween = self.create_tween()
	
	animation_target.scale.x = 1.2
	animation_target.scale.y = 0.9
	sprite.position.y = 2
	
	summon_spider_tween.tween_property(animation_target, "scale:x", 0.9, summon_speed)
	summon_spider_tween.parallel().tween_property(sprite, "modulate", Color(2.5, 2.5, 2.5), summon_speed)
	
	animation_timer.start(summon_speed)
	await animation_timer.timeout
	
	animation_target.scale = Vector2i(1, 1)
	sprite.position.y = 0
	
	var current_spider : Enemy = small_spider.instantiate()
	current_spider.global_position = enemy.global_position
	enemy.get_parent().add_child(current_spider)
	
	summon_spider_tween = self.create_tween()
	summon_spider_tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)
	
	await summon_spider_tween.finished
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
