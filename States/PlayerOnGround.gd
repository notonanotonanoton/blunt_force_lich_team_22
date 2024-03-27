extends State
class_name PlayerOnGround
@onready var player_character : CharacterBody2D = $"/root/PlayerCharacter" #get_node("PlayerCharacter")


func enter():
	pass # Replace with function body.

func exit():
	pass

func update(_delta: float):
	print(player_character)
	#print(player_character.velocity.y)
	pass
