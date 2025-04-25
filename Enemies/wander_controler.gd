extends Node2D

@export var wander_range : int = 32

@onready var start_positon = global_position
@onready var target_positon = global_position

@onready var timer = $Timer

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randi_range(-wander_range, wander_range), randi_range(-wander_range, wander_range))
	target_positon = start_positon + target_vector

func get_time_left():
	return timer.time_left
	
func start_wander_timer(duration):
	timer.start(duration)

func _on_timer_timeout() -> void:
	update_target_position()
