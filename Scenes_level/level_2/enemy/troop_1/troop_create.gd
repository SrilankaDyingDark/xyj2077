extends Node2D

var enemy_troop = preload("res://Scenes_level/level_2/enemy/troop_1/enemy_troop_1.tscn")

func troop_create():
	var troop_infunc = Global.instance_node(enemy_troop, Vector2(randf_range(40,280), 20), Global.world, global_rotation)
	

# 随机产生Enemy
func _on_timer_01_timeout() -> void:
	randomize()
	troop_create()
	$Timer_01.wait_time = int(randf_range(1,5))
	print($Timer_01.wait_time)
