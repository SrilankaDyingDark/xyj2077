extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
const ATTACK_RANGE = 40
const ATTACK_COOLDOWN = 0.5  # 攻击冷却时间（秒）

enum {
	MOVE,
	ROLL,
	ATTACK,
	COOLDOWN  # 新增冷却状态
}

var state = MOVE
var target_player: Node2D = null
var cooldown_timer: float = 0.0  # 冷却计时器

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
		COOLDOWN:
			cooldown_state(delta)  # 处理冷却状态

func move_state(delta):
	if target_player:
		var to_player = target_player.global_position - global_position
		var distance = to_player.length()
		
		if distance < ATTACK_RANGE && cooldown_timer <= 0:
			state = ATTACK
			return
		
		var direction = to_player.normalized()
		update_animation_direction(direction)
		animationState.travel("Run")
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()

func update_animation_direction(direction: Vector2):
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Run/blend_position", direction)
	animationTree.set("parameters/Attack/blend_position", direction)

func attack_state(delta):
	velocity = Vector2.ZERO
	
	if target_player:
		var direction = (target_player.global_position - global_position).normalized()
		animationTree.set("parameters/Attack/blend_position", direction)
	
	animationState.travel("Attack")

func cooldown_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Idle")
	cooldown_timer -= delta
	if cooldown_timer <= 0:
		state = MOVE

func attack_animation_finished():
	# 攻击结束后进入冷却状态
	cooldown_timer = ATTACK_COOLDOWN
	state = COOLDOWN

func _on_detection_player_body_entered(body: Node2D):
	target_player = body

func _on_detection_player_body_exited(body: Node2D):
	target_player = null
	state = MOVE  # 确保玩家离开后重置状态


func _on_hurt_box_area_entered(area: Area2D) -> void:
	queue_free()
