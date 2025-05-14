extends Control

signal start_game()

@onready var label = $RichTextLabel
@onready var animation_player = $AnimationPlayer
@onready var main_menu: Control = %MainMenu

var story_pages = [
	"2500年，人工智能已经深入每个人的意识，而历史的经典，已不再是过去的记忆，而是一个可以进入、感知、与之互动的现实。\n这是一个梦境与现实交织的时代，唯有勇敢者才能穿越时空，找寻遗失的真相。",
	"你，将化身为小狐狸——那个背负使命、充满智慧与力量的神猴。\n在这个奇幻的梦境中，你将不仅仅是一个旁观者，而是历史的参与者，挑战宿命的英雄。”",
	"但这片梦境并不安宁，青狮、白象、大鹏三大妖王正在狮驼岭中蠢蠢欲动，他们的力量足以摧毁一切。\n只有你，能在这场梦境般的冒险中，打破宿命，拯救这片被黑暗笼罩的天地。",
	"战斗才刚刚开始。你不仅要面对他们强大的力量，还需要破解他们背后隐藏的阴谋。\n每一场战斗，都是对你智慧与勇气的极限考验。这就是你的使命。\n你的梦境已经开始，而西游的传奇，正等着你去书写。"
]

var current_page = 0
var can_continue = true

func _ready():
	show_current_page()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and can_continue:
		current_page += 1
		if current_page < story_pages.size():
			show_current_page()
		else:
			get_tree().change_scene_to_file("res://world.tscn")

func show_current_page():
	can_continue = false
	# 先设置文本
	label.text = story_pages[current_page]
	# 立刻把 visible_characters 清为 0
	label.visible_characters = 0
	await get_tree().process_frame  # 等一帧，保证一切准备好
	# 再播放动画
	animation_player.play("TypeWriter")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "TypeWriter":  # 这里检测 TypeWriter 播放完了
		can_continue = true

func _on_main_menu_start_game() -> void:
	start_game.emit()
