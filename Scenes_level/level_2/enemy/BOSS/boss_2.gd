extends Node2D

# BOSS具有1/10免伤效果
######################################################
# 基础
var spin_speed = 100
var await_time = 0.2
var spawn_count = 4
var semi = 20

# 攻击
var att_begin = false
var boss_2_bullet = preload("res://Scenes_level/level_2/enemy/BOSS/boss_2_bullet.tscn")
var att_method = 0
var act_once = true
var switch_once = true

# 生存
var HP = 100
var hp_one = true

#受击
var white = 0


######################################################
func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if HP >0:
		$AnimatedSprite2D.play("Idle")
		var spin = $spin.rotation_degrees + spin_speed * delta
		$spin.rotation_degrees = fmod(spin, 360)
		
		if att_begin:
			if att_method == 0 and switch_once:
				$Timer_switch.start()
				switch_once = false
				
			if att_method != 0 and act_once:
				if $spin.get_child_count() == 0:
					spawn_place()  # 🔥 在攻击前生成子弹发射点
					boss_attack()
					$Timer_end.start()
					act_once = false
			
	if HP <= 0 and hp_one:
		att_begin = false
		hp_one = false
		HP = 0
		$AnimatedSprite2D.visible = false
		$Area2D/CollisionShape2D.call_deferred("set_disabled", true)
		$Timer_interval.stop()
	
	# boss受击变白
	var shader_mat := $AnimatedSprite2D.material as ShaderMaterial
	if shader_mat:
		shader_mat.set("shader_parameter/flash_state", white)
		if white >= 0:
			white -= 10 * delta


######################################################
func boss_attack():
	if att_method == 0:
		$Timer_interval.stop()
		
	if att_method == 1:
		spin_speed = 100
		await_time = 0.1
		spawn_count = 6
		$spin.rotation_degrees = 0
		$Timer_interval.wait_time = await_time
		$Timer_interval.start()
		
	if att_method == 2:
		spin_speed = 100
		await_time = 0.1
		spawn_count = 3
		$spin.rotation_degrees = 0
		$Timer_interval.wait_time = await_time
		$Timer_interval.start()		
		
	if att_method == 3:
		spin_speed = 0
		await_time = 0.2
		spawn_count = 12
		$spin.rotation_degrees = 0
		$Timer_interval.wait_time = await_time
		$Timer_interval.start()		


func spawn_place():
	var step = 2 * PI / spawn_count
	for i in range(spawn_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(semi, 0).rotated(step * i)
		spawn_point.position  = pos
		spawn_point.rotation = pos.angle()
		$spin.add_child(spawn_point)
		
# interval创建子弹
func _on_timer_interval_timeout() -> void:
	if att_method != 0:
		for s in $spin.get_children():
			var bullet_infunc = Global.instance_node(boss_2_bullet, s.global_position, Global.world, s.global_rotation)

# end
func _on_timer_end_timeout() -> void:
	att_method = 0
	switch_once = true
	for node in $spin.get_children():
		$spin.remove_child(node)

# switch
func _on_timer_switch_timeout() -> void:
	act_once = true
	att_method = int(randf_range(1,4))


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if HP > 0:
			white = 0.5
			
			#特防霰弹
			if area.bullet_type == 1:
				HP -= 0.1
		
			elif area.bullet_type == 2:
				HP -= 0.5
				
			elif area.bullet_type == 0:
				HP -= 0.2
