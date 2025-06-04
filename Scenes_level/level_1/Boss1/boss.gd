extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var speed = 50.0  # 移动速度
@onready var animation_tree = $AnimationTree  # 同级目录的AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")  # 动画状态机
@onready var playerDetectionZone = $detection
@export  var ACCELERATION = 30
@export  var MAX_SPEED = 30
@export  var FRICTION = 200
enum {
	CHASE,
	IDLE
}

func _ready():
	# 初始化动画树
	animation_tree.active = true
	update_animation(Vector2.LEFT)  # 默认向左

var state = IDLE

@onready var stats: Node = $Stats
@onready var hurtbox: Area2D = $Hurtbox

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _physics_process(delta):
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE

func accelerate_towards_point(point, delta):
	# 计算从Boss到玩家的方向向量
	var direction = (point - global_position).normalized()
	
	# 如果有方向，则更新动画
	if direction != Vector2.ZERO:
		update_animation(direction)
	
	# 计算加速度向量
	var acceleration = direction * ACCELERATION
	
	# 应用加速度到速度
	velocity += acceleration * delta
	
	# 限制最大速度
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	
	# 移动角色
	move_and_slide()

func update_animation(direction):
	# 修正动画方向参数（确保动画与移动方向一致）
	var animation_direction = direction
	animation_direction.y *= -1  # 反转Y轴方向，适配动画系统
	
	# 设置动画树的方向参数
	animation_tree.set("parameters/Walk/blend_position", animation_direction)
	
	if direction != Vector2.ZERO:
		animation_state.travel("Walk")
	else:
		# 无输入时保持最后方向的行走动画（替代Idle）
		animation_state.travel("Walk")

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_stats_no_health():
	queue_free() #设置当生命值为0时做什么，可以转入二阶段
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
