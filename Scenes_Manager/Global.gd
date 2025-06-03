extends Node2D

var world = null		# 获取当前场景

# 创建物体（子弹）
func instance_node(node, location, parent, rota):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	node_instance.global_position = location
	node_instance.global_rotation = rota
	return node_instance
	
