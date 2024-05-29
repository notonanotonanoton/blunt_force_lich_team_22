extends Node2D
@export var timer : Timer

# but this is the exact fucking problem we had before.
# that we couldn't ever be sure the box got initialised before we tried to interact with it
# that we solved by having the box be initialised at game-start and then teleporting it

# and now we're gonna get fucked by it again
# since we decided to *stop* doing that

# ( complain about it to anton )

# so until somone figures out a better idea, we are using the retarded timer


func _ready():
	timer.one_shot = true
	timer.autostart = false
	timer.start(0.2)


func _on_timer_timeout():
	for child in get_parent().get_children():
		print(child)
		if child is PlayerBox:
			child.global_position = child.global_position+Vector2(195, 0)
