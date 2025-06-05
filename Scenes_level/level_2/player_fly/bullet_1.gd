extends Area2D

var velocity = Vector2(0,-1)
var speed = 1000
var bullet_type = 1

func _process(delta):
	$AnimatedSprite2D.play('Idle')
	global_position += velocity.rotated(rotation) * speed * delta


# 子弹出屏幕后消失
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

# 子弹碰撞后消失
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()
