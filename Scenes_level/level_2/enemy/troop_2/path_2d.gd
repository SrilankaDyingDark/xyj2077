extends Path2D

var enemy_troop_2 = preload("res://Scenes_level/level_2/enemy/troop_2/enemy_troop_2.tscn")
var time = 0

func _ready():
	troop_create_2()


func _process(delta: float) -> void:
	if time >= 5:
		$Timer.wait_time = int(randf_range(2, 8))
		$Timer.start()
		time = 0

#########################
#---------函数快---------#
#########################

func troop_create_2() -> void:
	await get_tree().create_timer(0.1).timeout  # 若需在_ready中等待，最好先加一点微小等待
	for i in range(5):
		var enemy02_infunc = Global.instance_node(
			enemy_troop_2,
			Vector2(global_position.x, global_position.y - 50),
			self,
			global_rotation
		)
		await get_tree().create_timer(0.3).timeout
		time += 1

func _on_timer_timeout() -> void:
	troop_create_2()
