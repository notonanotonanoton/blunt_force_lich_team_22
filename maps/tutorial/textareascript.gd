extends Area2D

@export var complex : bool = false
@export var timer : Timer
var texteditarray : Array[TextEdit]
var active_text_id : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child : Node in get_children():
		if child is TextEdit:
			child.visible = false;
	if complex:
		timer.autostart = false
		timer.wait_time = 3
		timer.one_shot = true


func _on_body_entered(body : Node2D) -> void:

		print(body)
		if body is PlayerCharacter:
			if complex == false:
				for child : Node in get_children():
					if child is TextEdit:
						child.visible = true;
			else:
				for child : Node in get_children():
					if child is TextEdit:
						texteditarray.append(child)
				complex_text()


func complex_text() -> void:

		if active_text_id < texteditarray.size():
			for child : Node in texteditarray:
				if child.id == active_text_id-1:
					child.visible = false;
				if child.id == active_text_id:
					child.visible = true;
					timer.start()


func _on_body_exited(body : Node2D) -> void:

	if body is PlayerCharacter:
		active_text_id = 0;
		for child : Node in get_children():
			if child is TextEdit:
				child.visible = false;


func _on_timer_timeout() -> void:
	active_text_id+=1;
	complex_text()
