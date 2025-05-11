extends Node2D

@onready var story_label = $RichTextLabel

func _ready():
	story_label.bbcode_enabled = true
	story_label.text = "[center][b]勇者的传说[/b][/center]"
