extends Control

signal start_game()
@onready var buttons_v_box: VBoxContainer = %ButtonsVBox
@onready var menu_move_sound: AudioStreamPlayer2D = $MenuMoveSound
@onready var menu_select_sound: AudioStreamPlayer2D = $MenuSelectSound

func _ready() -> void:
	focus_button()
	connect_button_signals()

func _on_start_game_button_pressed() -> void:
	menu_select_sound.play()
	start_game.emit()
	#hide()

func _on_quit_button_pressed() -> void:
	menu_select_sound.play()
	get_tree().quit()

func _on_visibility_changed() -> void:
	if visible:
		focus_button()

func focus_button() -> void:
	if buttons_v_box:
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
			button. grab_focus()

func connect_button_signals():
	for i in buttons_v_box.get_children():
		if i is Button:
			i.focus_entered.connect(_on_button_focus_entered.bind(i))

func _on_button_focus_entered(button: Button) -> void:
	# 播放移动音效
	menu_move_sound.play()
