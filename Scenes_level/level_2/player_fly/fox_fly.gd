extends CharacterBody2D
class_name Player_fly

@export var hp: int = 100


var acc: int = 50
var max_speed: int = 300
var friction: int = 20
var move_speed: float = 200

var bullet = preload("res://Scenes_level/level_2/player_fly/bullet.tscn")
var shoot_begin =true


func _process(_delta):
	# 运动
	var move_vector: Vector2 = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	velocity = move_vector * move_speed
	move_and_slide()
	
	# 限制运动范围
	global_position.x = clamp(global_position.x,10,310)
	global_position.y = clamp(global_position.y,10,170)
	
	if Input.is_action_pressed('attack') and shoot_begin:
		shoot()
		shoot_begin = false
		# 子弹发射间隔时间
		$Timer_shoot.start()

# 子弹射击
func shoot():
	var bullet_infunc = Global.instance_node(bullet, $Marker2D.global_position, Global.world, global_rotation)

	

func _on_timer_shoot_timeout() -> void:
	shoot_begin = true
