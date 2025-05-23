extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_pressed():
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
