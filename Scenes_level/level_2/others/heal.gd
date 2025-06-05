extends Area2D

var velocity = Vector2(0,1)
var speed = 50


#########
#-执行层-#
#########
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$AnimatedSprite2D.play("Idle")
	global_position += velocity.rotated(rotation) * speed * delta


#########
#-代码块-#
#########


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
