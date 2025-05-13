extends Node2D

@onready var main_menu: Control = $MainMenu
@onready var story_scene: Control = $StoryScene

func _ready():
	main_menu.start_game.connect(_on_start_game)

func _on_start_game():
	main_menu.hide()
	get_tree().change_scene_to_file("res://Scenes/TypeWriter.tscn")
