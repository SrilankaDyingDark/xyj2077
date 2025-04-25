extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
const WANDER_TIMER_DURATION = 3 

@export  var ACCELERATION = 300
@export  var MAX_SPEED = 30
@export  var FRICTION = 200
@export var WANDER_TARGET_RANGE = 5
#@export var item: InvItem

enum {
	IDLE,
	WANDER,
	CHASE
}

#var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

@onready var sprite = $AnimatedSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softcollision = $SoftCollision
@onready var wanderController = $WanderControler
@onready var animationPlayer = $AnimationPlayer
#@onready var particles = $GPUParticles2D

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	velocity  = velocity .move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_positon, delta)
			if global_position.distance_to(wanderController.target_positon) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softcollision.is_colliding():
		velocity += softcollision.get_push_vector() * delta * 400
	move_and_slide()

func accelerate_towards_point(point, delta):
	# var direction = (player.global_position - global_position).normalized()
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randi_range(1, WANDER_TIMER_DURATION))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	return state_list.pick_random()

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

func _on_hurtbox_invinciblility_started() -> void:
	animationPlayer.play("Start")

func _on_hurtbox_invinciblility_ended() -> void:
	animationPlayer.play("Stop")
