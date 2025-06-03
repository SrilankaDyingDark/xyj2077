extends Area2D

@export var next_scene: String




func _on_body_entered(body: Node2D) -> void:
	if body is Player or Player_fly:
		get_tree().change_scene_to_file.call_deferred(next_scene)
