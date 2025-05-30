extends Control

signal start_game()

@onready var label = $RichTextLabel
@onready var animation_player = $AnimationPlayer
@onready var main_menu: Control = %MainMenu
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

var story_pages = [
	"二千五百载，众生沉梦，神智冥通\n往史不作故纸，幻境已成真形。",
	"汝本灵狐，承天道轮转之命\n梦与真交汇，惟志坚者，方可穿梭古今，觅得真如正果。",
	"狮驼岭动，青狮怒啸，白象踏岳，大鹏裂空，三妖欲覆乾坤\n此乃天劫将至，岂容袖手？汝为逆命行者，破局唯一之人",
	"梦未终，战方起\n破妖谋、斗强敌、解宿命……\n此行，正是你的西游传……"
]



var current_page = 0
var can_continue = true

func _ready():
	show_current_page()
	color_rect.color.a = 0 #fade-in and fade-out

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and can_continue:
		current_page += 1
		if current_page < story_pages.size():
			show_current_page()
		else:
			#fade-in 
			var tween := create_tween()
			tween.tween_property(color_rect, "color:a", 1, 0.2)
			await tween.finished
			
			get_tree().change_scene_to_file("res://world.tscn")
			
			#fade-out
			tween = create_tween()
			tween.tween_property(color_rect, "color:a", 0, 0.2)

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
