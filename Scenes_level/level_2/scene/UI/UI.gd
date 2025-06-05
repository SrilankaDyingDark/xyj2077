extends CanvasLayer

var score: int = 0

func _process(delta):
	$Label.text = str(score)
	
func get_score(value):
	var score_infunc = value
	score += score_infunc
	
