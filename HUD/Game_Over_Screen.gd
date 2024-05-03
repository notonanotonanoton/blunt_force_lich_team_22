extends CanvasLayer
var player_character : PlayerCharacter 

func _ready():
	visible = false;
	
func _on_children_entered() -> void: 
	await get_tree().create_timer(0.5).timeout
	for node in get_parent().get_children():
		if node is PlayerCharacter:
			player_character = node
	
	player_character.player_death.connect(_on_player_character_player_death)

func _on_exit_button_pressed():
	#print("exit pressed")
	get_tree().quit()

func _on_retry_button_pressed():
	#print("retry button pressed")
	get_tree().reload_current_scene()

func _on_player_character_player_death():	
	visible = true
