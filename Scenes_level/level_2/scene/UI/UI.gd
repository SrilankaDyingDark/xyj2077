extends CanvasLayer

var score: int = 0
var boss2 = null


######################################
func _process(delta):
	# 得分板
	$Label.text = str(score)
	
	
	# BOSS2血条
	$TextureProgressBar_2.value = get_parent().get_node("BOSS_2").HP
	

######################################
func get_score(value):
	var score_infunc = value
	score += score_infunc

func BOSS2_health_show():
	$TextureProgressBar_2.visible = true
