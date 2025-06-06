extends CharacterBody2D
class_name Player_fly

@export var hp: int = 100

var acc := 1600
var max_speed := 200
var friction := 1600
var HP := 3
var death := false
const MAX_HP = 3

var bullet_type = 0
var special_bullet = true
var bullet = preload("res://Scenes_level/level_2/player_fly/bullet_1.tscn")
var Mbullet = preload("res://Scenes_level/level_2/player_fly/bullet_2.tscn")
var shoot_begin = true

var white = 0		# 受到攻击变白

# 子弹控制
var wait_time = 10
var one_shot = true
var autostart = false

###################################################
func _physics_process(delta):
	if not death:
		movement(delta)
		$AnimatedSprite2D.play('Idle')
		attack()
		health_control()
		
		var shader_mat := $AnimatedSprite2D.material as ShaderMaterial
		if shader_mat:
			shader_mat.set("shader_parameter/flash_state", white)
			if white >= 0:
				white -= 5 * delta
				
				
######################################################
func movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * max_speed, acc * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	set_velocity(velocity)
	move_and_slide()

	global_position.x = clamp(global_position.x, 10, 310)
	global_position.y = clamp(global_position.y, 10, 170)

func attack():
	if Input.is_action_pressed('attack') and shoot_begin:
		match bullet_type:
			0: shoot()
			1: S_shoot()
			2: M_shoot()
		shoot_begin = false
		$Timer_shoot.start()

func shoot():
	Global.instance_node(bullet, $Marker2D.global_position, Global.world, global_rotation)

func S_shoot():
	for angle in [-0.4, -0.2, 0, 0.2, 0.4]:
		Global.instance_node(bullet, $Marker2D.global_position, Global.world, global_rotation + angle)

func M_shoot():
	Global.instance_node(Mbullet, $Marker2D.global_position, Global.world, global_rotation)

func health_control():
	get_tree().root.get_node_or_null("level_2/UI/TextureProgressBar").value = HP
	if HP <= 0:
		death = true
		$AnimatedSprite2D.play('death')
		$Area2D/CollisionShape2D.call_deferred('set_disabled', true)

func heal(value):
	if HP < MAX_HP:
		HP += value

func wound(value):
	if HP > 0:
		HP -= value
		white = 1.0
		
func _on_timer_shoot_timeout():
	shoot_begin = true

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("enemy"):
		wound(1)
		white = 1.0
	if area.is_in_group('heal'):
		heal(1)
		area.queue_free()

	if area.is_in_group("O"):
		bullet_type = 0
		area.queue_free()
		$Timer_bllet_reset.stop()		# 停止限时

	if area.is_in_group("S"):
		bullet_type = 1
		area.queue_free()
		$Timer_bllet_reset.start()		# 启动限时
		
	if area.is_in_group("M"):
		bullet_type = 2
		area.queue_free()
		$Timer_bllet_reset.start()		# 启动限时
		
func _on_timer_bllet_reset_timeout() -> void:
	bullet_type = 0			
		
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.visible = false
