extends CanvasLayer

var score: int = 0
var boss2 = null



func _process(delta):
	$Label.text = str(score)
	
	if boss2 == null:
		var node = get_node_or_null("res://Scenes_level/level_2/enemy/BOSS/boss_2.tscn")
		if node:
			boss2 = node
			boss2.connect("hp_changed", Callable(self, "_on_boss2_hp_changed"))

func _on_boss2_hp_changed(hp):
	$TextureProgressBar_boss2.value = hp

	
func get_score(value):
	var score_infunc = value
	score += score_infunc
	
func boss2_health_show():
	$TextureProgressBar_boss2.visible = true
