extends CharacterBody2D

# 敌人属性
@export var speed: float = 150.0
@export var attack_range: float = 100.0
@export var attack_cooldown: float = 1.5
@export var detection_range: float = 400.0

# 节点引用
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_timer: Timer = $AttackTimer

# 状态变量
var target: Node2D = null
var can_attack: bool = true
var current_state: String = "idle"
var last_direction: Vector2 = Vector2.DOWN

func _ready():
	attack_timer.wait_time = attack_cooldown
	attack_timer.timeout.connect(_on_attack_cooldown_finished)

func _physics_process(_delta):
	# 寻找玩家
	if target == null:
		find_target()
		return
	
	# 计算到目标的距离和方向
	var direction = global_position.direction_to(target.global_position)
	var distance = global_position.distance_to(target.global_position)
	
	# 更新最后方向用于动画
	if direction.length() > 0:
		last_direction = direction
	
	# 状态判断
	if distance <= attack_range and can_attack:
		current_state = "attack"
		attack()
	elif distance <= detection_range:
		current_state = "chase"
		chase(direction)
	else:
		current_state = "idle"
	
	# 更新动画
	update_animation()

func find_target():
	# 这里假设玩家组为"player"，可以根据实际情况调整
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		target = players[0]

func chase(direction: Vector2):
	velocity = direction * speed
	move_and_slide()

func attack():
	if !can_attack:
		return
	
	# 执行攻击逻辑
	can_attack = false
	attack_timer.start()
	
	# 这里可以添加实际的攻击效果，如生成伤害区域等
	# 例如: spawn_hitbox(last_direction)
	
	print("Boss发动攻击!")

func _on_attack_cooldown_finished():
	can_attack = true

func update_animation():
	var anim_name = current_state + "_" + get_direction_suffix(last_direction)
	
	# 检查动画是否存在
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	else:
		# 回退到默认动画
		animation_player.play("idle_" + get_direction_suffix(last_direction))

func get_direction_suffix(direction: Vector2) -> String:
	# 根据方向返回动画后缀
	if abs(direction.x) > abs(direction.y):
		return "left" if direction.x < 0 else "right"
	else:
		return "up" if direction.y < 0 else "down"

# 可选：添加伤害检测
func _on_hitbox_area_entered(area):
	if area.is_in_group("player_attack"):
		# 处理受到伤害的逻辑
		take_damage(area.damage)

func take_damage(amount: int):
	# 受伤逻辑
	print("Boss受到伤害: ", amount)
	# 可以添加受伤动画等
