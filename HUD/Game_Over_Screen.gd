extends CanvasLayer

#this has to be replaced or altered with something
#that works even after replacing the tilemap 
@export var player_character : PlayerCharacter 

func _ready() -> void:
	visible = false;
	player_character.player_death.connect(_on_player_character_player_death)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_player_character_player_death() -> void:	
	visible = true
