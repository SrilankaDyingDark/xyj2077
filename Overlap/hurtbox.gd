extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible : bool = false : set = set_invincible

@onready var timer = $Timer

signal invinciblility_started
signal invinciblility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invinciblility_started")
	else:
		emit_signal("invinciblility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout():
	# Must use self, to call set_invincible()
	self.invincible = false

func _on_invinciblility_started():
	# monitorable = true
	set_deferred("monitoring", false)

func _on_invinciblility_ended():
	# monitorable = true
	set_deferred("monitoring", true)
