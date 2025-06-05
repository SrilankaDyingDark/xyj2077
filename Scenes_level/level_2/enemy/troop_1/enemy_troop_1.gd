extends Area2D

var velocity = Vector2(0,1)
var speed = 50
var HP = 2
var act_once = true
var is_dying = false

@export var heal: PackedScene
@export var S: PackedScene
@export var M: PackedScene
var object = 0

func _process(delta):
	if not is_dying:
		$AnimatedSprite2D.play("Idle")
		global_position += velocity.rotated(rotation) * speed * delta
	
	# 死亡判断
	if HP <= 0 and act_once:
		is_dying = true
		$AnimatedSprite2D.play("death")
		speed = 0
		$CollisionShape2D.call_deferred("set_disabled", true)
		
		# 战利品掉落
		object = int(randf_range(0,10))
		if object == 1:
			var object_infunc = Global.instance_node(heal, global_position, Global.world, global_rotation)
		if object == 2:
			var object_infunc = Global.instance_node(S, global_position, Global.world, global_rotation)
		if object == 3:
			var object_infunc = Global.instance_node(M, global_position, Global.world, global_rotation)
		
		
		act_once = false


#########################
#---------函数快---------#
#########################

# 碰撞交互
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		# 受击变红
		$AnimatedSprite2D.modulate = Color(1, 0, 0)
		$Timer_red.start()
		
		if area.bullet_type == 1:
			HP -= 0.5
	
		elif area.bullet_type == 2:
			HP -= 2
			
		elif area.bullet_type == 0:
			HP -= 1
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.death == false:
			HP -= 2
			if body.has_method("wound"):
				body.wound(1)


# 收尾动画
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		get_parent().get_node("UI").get_score(10)
		queue_free()

# 0.15秒后回复原色
func _on_timer_red_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
