extends Area2D

signal send_box_status

func _send_box_status():
	emit_signal("send_box_status", get_overlapping_bodies())

func _on_player_character_request_box_status():
	_send_box_status()
