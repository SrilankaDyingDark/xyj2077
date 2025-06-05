extends Node2D

var speed = 200


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += transform.x * speed * delta
	

# 离开屏幕后消失
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

# 碰撞角色后消失
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# 判断角色存活，以及对角色伤害
		if body.death == false:
			queue_free()
			if body.has_method("wound"):
				body.wound(1)
		
