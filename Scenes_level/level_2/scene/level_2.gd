extends Node2D

var run_once = true
# 确保优先运行场景给全局变量赋值，否则报错（空值）
func _ready():
	Global.world = self
func _exit_tree() -> void:
	Global.world = null

func _process(delta):
	if $UI.score >= 50 and run_once:
		$AnimationPlayer.play("BOSS_coming")
		$UI.boss2_health_show()
		$BOSS_2.att_begin = true
		run_once = false
		
