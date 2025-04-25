extends AnimatedSprite2D

#@onready var animatedSprite = $AnimatedSprite2D
func _ready():
#	connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	connect("animation_finished", Callable(self,"_on_animation_finished"))
	play("Animate")

#func _ready():
	#print("animatedSprite:", animatedSprite)
	##animatedSprite.frame = 0
	#animatedSprite.play("Animate")

func _on_animation_finished():
	queue_free()
