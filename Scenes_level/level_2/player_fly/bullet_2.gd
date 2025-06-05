extends Area2D

var velocity = Vector2(0,-1)
var speed = 1000
var disappear = true
var bullet_type = 2


func _process(delta):
	global_position += velocity.rotated(rotation) * speed * delta


# 子弹出屏幕后消失
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


# 子弹碰撞后消失
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and disappear:
		speed = 0
		$AnimationPlayer.play("Idle")
		$Timer_disappear.start()
		disappear = false

# 子弹消失
func _on_timer_disappear_timeout() -> void:
	queue_free()
