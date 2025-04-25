extends Area2D
# 防止蝙蝠重叠
func is_colliding():
	var areas =  get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var area = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		area = area[0] 
		push_vector = area.global_position.direction_to(global_position)
	return push_vector
