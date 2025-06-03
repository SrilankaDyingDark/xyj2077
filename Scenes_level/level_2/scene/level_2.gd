extends Node2D

# 确保优先运行场景给全局变量赋值，否则报错（空值）
func _ready():
	Global.world = self
func _exit_tree() -> void:
	Global.world = null
	
